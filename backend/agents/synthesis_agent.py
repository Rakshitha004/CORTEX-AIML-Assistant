import os
import re
import time
import requests
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")

# ── Models ──────────────────────────────────────────────────────────────────
FAST_MODEL = "meta-llama/Llama-3.3-70B-Instruct-Turbo"   # Simple queries — 3-4 sec
SQL_MODEL  = "Qwen/Qwen3-235B-A22B-Instruct-2507-FP8"    # SQL formatting
RAG_MODEL  = "Qwen/Qwen3-235B-A22B-Instruct-2507-FP8"    # Complex RAG queries

# ── Query complexity detector ────────────────────────────────────────────────
COMPLEX_KEYWORDS = [
    "compare", "difference", "vs", "versus", "explain", "why", "how does",
    "analyze", "analyse", "list all", "all students", "every", "across all",
    "research", "publication", "project", "collaboration", "multiple",
    "all faculty", "all subjects", "entire", "detailed", "comprehensive"
]

SIMPLE_KEYWORDS = [
    "who is", "what is", "hod", "head", "name", "vision", "mission",
    "topper", "highest cgpa", "how many", "when", "where", "which year",
    "phone", "email", "contact", "address", "designation"
]

def detect_complexity(query: str) -> str:
    """Returns 'simple' or 'complex'"""
    q = query.lower()
    if any(k in q for k in COMPLEX_KEYWORDS):
        return "complex"
    if any(k in q for k in SIMPLE_KEYWORDS) or len(query.split()) <= 6:
        return "simple"
    return "simple"  # default to fast model when unsure


def pick_rag_model(query: str) -> tuple:
    """Returns (model, max_tokens) based on query complexity"""
    complexity = detect_complexity(query)
    if complexity == "simple":
        print(f"[Routing] Simple query → FAST MODEL (Llama 70B)")
        return FAST_MODEL, 1000
    else:
        print(f"[Routing] Complex query → FULL MODEL (Qwen 235B)")
        return RAG_MODEL, 4000


def compute_grounding_score(query: str, answer: str, context: str) -> float:
    """Improved grounding: measures how much the ANSWER is grounded in context"""
    try:
        answer_words = set(re.findall(r'\b\w{4,}\b', answer.lower()))
        context_words = set(re.findall(r'\b\w{4,}\b', context.lower()))

        if not answer_words:
            return 0.0

        overlap = answer_words & context_words
        score = len(overlap) / len(answer_words)

        if len(context) > 1000:
            score = min(1.0, score + 0.05)
        if len(answer) > 200:
            score = min(1.0, score + 0.05)

        return round(min(1.0, score), 2)
    except Exception:
        return 0.0


def fallback_sql_format(query: str, result: list) -> str:
    """Clean fallback formatter"""
    if not result:
        return "No records found."

    headers = list(result[0].keys())
    table = "| # | " + " | ".join(h.upper() for h in headers) + " |\n"
    table += "|---|" + "---|" * len(headers) + "\n"

    display_rows = result[:20]
    for i, row in enumerate(display_rows, 1):
        table += f"| {i} | " + " | ".join(str(v) for v in row.values()) + " |\n"

    if len(result) > 20:
        table += f"\n*Showing 20 of {len(result)} records.*"

    table += f"\n\n**Total records:** {len(result)}"
    return table


def format_sql_result(query, result):
    """Format SQL results using AI"""
    if not result:
        return "No records found.", 0.0

    display_result = result[:50]
    result_str = ""
    for row in display_result:
        result_str += str(row) + "\n"

    if len(result) > 50:
        result_str += f"\n(Showing first 50 of {len(result)} total records)"

    prompt = f"""You are CORTEX, an AI assistant for the AIML department at DSCE Bengaluru.

Convert these database results into a clean, human-readable answer.

Rules:
1. ALWAYS format as a neat markdown table first
2. Use ACTUAL column names from the data — never hardcode wrong column names
3. For CGPA data: | # | Name | USN | CGPA |
4. For SGPA data: | # | Name | USN | SGPA |
5. For subject grades: | # | Subject | Grade |
6. For batch comparison: show both batches side by side
7. After table, write ONE brief summary sentence
8. Never show raw dict format like {{'name': 'xyz'}}
9. For grades: O=Outstanding, A+=Excellent, A=Very Good, B+=Good, B=Above Average, C=Average, P=Pass, F=Fail
10. If comparison query → highlight differences clearly

Database Results:
{result_str}

Question: {query}

Answer:"""

    for attempt in range(3):
        try:
            response = requests.post(
                "https://api.together.xyz/v1/chat/completions",
                headers={
                    "Authorization": f"Bearer {TOGETHER_API_KEY}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": SQL_MODEL,
                    "messages": [{"role": "user", "content": prompt}],
                    "max_tokens": 2000,
                    "temperature": 0.1
                },
                timeout=120
            )
            data = response.json()

            if "choices" not in data:
                print(f"[SQL Together AI] No choices (attempt {attempt+1}): {data}")
                if attempt < 2:
                    time.sleep(2)
                    continue
                else:
                    raise Exception(f"No choices after 3 attempts: {data}")

            answer = data["choices"][0]["message"]["content"]
            grounding = round(min(1.0, len(result) / 10), 2) if result else 0.0
            return answer, grounding

        except Exception as err:
            print(f"TOGETHER ERROR SQL (attempt {attempt+1}): {err}")
            if attempt < 2:
                time.sleep(2)
                continue

    print("[SQL Fallback] Returning formatted table")
    return fallback_sql_format(query, result), 0.5


def format_rag_result(query, context):
    """Format RAG results using AI — routes to fast or full model based on complexity"""
    context_str = str(context).strip()
    context_str = re.sub(r"\\n", "\n", context_str)
    context_str = re.sub(r"\n{3,}", "\n\n", context_str)
    context_str = re.sub(r"\s{3,}", " ", context_str)
    context_str = context_str.strip()
    context_str = context_str[:20000]

    # ── Route to correct model based on query complexity ──
    model, max_tokens = pick_rag_model(query)

    prompt = f"""You are CORTEX, an AI assistant for the AIML department at DSCE Bengaluru.
Answer strictly based ONLY on the provided context. Follow these rules:
1. COMPLETENESS: If the question asks for a list, include EVERY item found in context.
2. FAITHFULNESS: Never invent any name or fact not in the context.
3. 3. FORMAT: For faculty lists — ONLY include people with these designations: Professor, Associate Professor, Assistant Professor, Head of Department, HOD, Lecturer. EXCLUDE student names, participant names, or anyone without a faculty designation. For research — bullet points. For events — bullet points.
4. UNKNOWN: If context does not contain the answer say exactly: 'I do not have enough information about that.'
5. Never use placeholders like [Name]. Only real names from context.
6. Keep response focused and clear.
7. For comparison queries → use tables to compare clearly.
8. For lists → include EVERY item, do not truncate.

Context:
{context_str}

Question: {query}

Answer:"""

    for attempt in range(3):
        try:
            response = requests.post(
                "https://api.together.xyz/v1/chat/completions",
                headers={
                    "Authorization": f"Bearer {TOGETHER_API_KEY}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": model,
                    "messages": [{"role": "user", "content": prompt}],
                    "max_tokens": max_tokens,
                    "temperature": 0.1
                },
                timeout=120
            )
            data = response.json()

            if "choices" not in data:
                print(f"[RAG Together AI] No choices (attempt {attempt+1}): {data}")
                if attempt < 2:
                    time.sleep(2)
                    continue
                else:
                    raise Exception(f"No choices after 3 attempts: {data}")

            answer = data["choices"][0]["message"]["content"]
            grounding_score = compute_grounding_score(query, answer, context_str)
            return answer, grounding_score

        except Exception as err:
            print(f"TOGETHER ERROR RAG (attempt {attempt+1}): {err}")
            if attempt < 2:
                time.sleep(2)
                continue

    print("[RAG Fallback] Returning raw context")
    fallback = f"Based on available information from our documents:\n\n{context_str[:3000]}"
    return fallback, 0.3


def format_response(query, result):
    """Returns (answer, grounding_score)"""
    if not result:
        return "No information found.", 0.0

    if isinstance(result, list):
        if len(result) == 0:
            return "No records found.", 0.0
        return format_sql_result(query, result)

    return format_rag_result(query, result)