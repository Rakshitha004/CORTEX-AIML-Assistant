import re
import requests
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

TOGETHER_API_KEY = "a60fb67ec58586166da63dfbbc672210cd4d9815a873a1684f60ca22c90e5a62"

SQL_MODEL = "Qwen/Qwen3-235B-A22B-Instruct-2507-FP8"
RAG_MODEL = "Qwen/Qwen3-235B-A22B-Instruct-2507-FP8"


def compute_grounding_score(query: str, context: str) -> float:
    """
    Compute a grounding score between 0 and 1 based on keyword overlap
    between the query and the retrieved context. Fast, no extra API calls.
    """
    try:
        query_words = set(re.findall(r'\b\w{4,}\b', query.lower()))
        context_words = set(re.findall(r'\b\w{4,}\b', context.lower()))
        if not query_words:
            return 0.0
        overlap = query_words & context_words
        score = round(len(overlap) / len(query_words), 2)
        # Boost score if context is long enough (good retrieval)
        if len(context) > 500:
            score = min(1.0, score + 0.1)
        return round(min(1.0, score), 2)
    except Exception:
        return 0.0


def format_sql_result(query, result):
    """Format SQL results using AI for clean readable answers"""
    if not result:
        return "No records found.", 0.0

    result_str = ""
    for row in result:
        result_str += str(row) + "\n"

    prompt = f"""You are CORTEX, an AI assistant for the AIML department at DSCE Bengaluru.

You have received database query results. Convert them into a clean, natural, human-readable answer.

Rules:
1. Never show raw dictionary format like {{'name': 'xyz'}}
2. ALWAYS format results in a markdown table first
3. IMPORTANT: Use the ACTUAL column names from the database results - never hardcode CGPA if data shows SGPA
4. Look at the actual keys in the result data to determine correct column headers
5. For CGPA data use: | # | Name | USN | CGPA |
6. For SGPA data use: | # | Name | USN | SGPA | or | # | Name | USN | Avg SGPA |
7. For subject grades use: | # | Semester | Subject Code | Subject Name | Grade |
8. For mixed results include all relevant columns based on actual data
9. After the table, write a brief natural language summary of the results
10. Be concise and professional
11. Never invent data not in the results
12. For grades use: O=Outstanding, A+=Excellent, A=Very Good, B+=Good, B=Above Average, C=Average, P=Pass, F=Fail
13. For rankings/toppers - add rank number in first column
14. Summary should be conversational and insightful based on the data

Database Results:
{result_str}

User Question: {query}

Answer (table first, then natural summary):"""
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
                "max_tokens": 1000,
                "temperature": 0.1
            },
            timeout=60
        )
        data = response.json()
        answer = data["choices"][0]["message"]["content"]
        # SQL grounding score based on how many rows returned
        grounding = round(min(1.0, len(result) / 10), 2) if result else 0.0
        return answer, grounding
    except Exception as err:
        print(f"TOGETHER ERROR: {err}")
        if not result:
            return "No records found.", 0.0
        headers = list(result[0].keys())
        table = "| # | " + " | ".join(headers) + " |\n"
        table += "|---|" + "|---|" * len(headers) + "\n"
        for i, row in enumerate(result[:10], 1):
            table += f"| {i} | " + " | ".join(str(v) for v in row.values()) + " |\n"
        return table, 0.5


def format_rag_result(query, context):
    """Format RAG results using AI for clean readable answers"""
    context_str = str(context).strip()
    context_str = re.sub(r"\\n", "\n", context_str)
    context_str = re.sub(r"\n{3,}", "\n\n", context_str)
    context_str = re.sub(r"\s{3,}", " ", context_str)
    context_str = context_str.strip()
    context_str = context_str[:25000]

    # Compute grounding score BEFORE calling the LLM
    grounding_score = compute_grounding_score(query, context_str)

    prompt = f"""You are CORTEX, an AI assistant for the AIML department at DSCE Bengaluru.
Answer strictly based ONLY on the provided context. Follow these rules:
1. COMPLETENESS: If the question asks for a list, include EVERY SINGLE item found in the context. Do NOT stop early.
2. FAITHFULNESS: Never invent any name or fact not in the context.
3. FORMAT: For faculty — numbered list with name and designation. For research — bullet points. For events/placements — bullet points.
4. UNKNOWN: If context does not contain the answer say exactly: 'I do not have enough information about that.'
5. NEVER summarize or truncate lists. List everything the context provides.
6. Never use placeholders like [Name]. Only real names from context.

Context:
{context_str}

Question: {query}

Answer (list ALL real items found in context, do not stop early):"""

    try:
        response = requests.post(
            "https://api.together.xyz/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {TOGETHER_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": RAG_MODEL,
                "messages": [{"role": "user", "content": prompt}],
                "max_tokens": 4000,
                "temperature": 0.1
            },
            timeout=60
        )
        data = response.json()
        answer = data["choices"][0]["message"]["content"]
        return answer, grounding_score
    except Exception as err:
        print(f"TOGETHER ERROR: {err}")
        return f"Together AI failed: {str(err)}", 0.0


def format_response(query, result):
    """Returns (answer, grounding_score)"""
    if not result:
        return "No information found.", 0.0

    # SQL result - list of dicts
    if isinstance(result, list):
        if len(result) == 0:
            return "No records found.", 0.0
        return format_sql_result(query, result)

    # RAG result - string context
    return format_rag_result(query, result)