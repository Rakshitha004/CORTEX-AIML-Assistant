import os
import requests

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")

def detect_intent(query: str) -> str:
    """
    Fully dynamic intent detection using LLM
    No hardcoded keywords — handles ANY query
    """
    prompt = f"""You are an intent classifier for AIML department chatbot at DSCE Bangalore.

DATABASE has ONLY these 3 tables:
1. student_results (usn, name, cgpa)
2. semester_results (usn, semester, sgpa)
3. subject_grades (usn, semester, subject_code, subject_name, grade)

SIMPLE RULE:
→ Can this query be answered from student marks/CGPA/grades database?
   YES → student_query
   NO  → knowledge_query

EXAMPLES:
"Who has highest CGPA?" → student_query
"List top 5 students" → student_query
"How many students passed?" → student_query
"Show students with CGPA above 9" → student_query
"Compare 2020 vs 2021 batch results" → student_query
"What is average CGPA?" → student_query
"Who got O grade in maths?" → student_query
"Who is the HOD?" → knowledge_query
"List all faculty" → knowledge_query
"Research areas of Dr. Aruna" → knowledge_query
"Tell me about Aventus hackathon" → knowledge_query
"Which companies visited for placement?" → knowledge_query
"List industry visits by AIML students" → knowledge_query
"What is vision of AIML department?" → knowledge_query
"What MOUs does AIML have?" → knowledge_query
"What FDPs were conducted?" → knowledge_query
"Tell me about ISRO visit" → knowledge_query
"What workshops happened?" → knowledge_query
"List internship companies" → knowledge_query
"What labs are in AIML?" → knowledge_query
"What is the syllabus?" → knowledge_query
"How many students did internships?" → student_query
"Which companies offered internships?" → knowledge_query

IMPORTANT:
- "list students who..." = student_query (needs database)
- "list companies/faculty/events..." = knowledge_query (needs PDFs)
- "how many students..." = student_query (needs database count)
- "industry visit/placement/internship company" = knowledge_query
- When in doubt → knowledge_query

Query: "{query}"

Reply ONLY: student_query OR knowledge_query"""

    try:
        response = requests.post(
            "https://api.together.xyz/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {TOGETHER_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": "meta-llama/Llama-3.3-70B-Instruct-Turbo",
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0,
                "max_tokens": 10
            },
            timeout=30
        )
        result = response.json()

        if "choices" not in result:
            raise Exception(f"API error: {result}")

        intent = result["choices"][0]["message"]["content"].strip().lower()
        print(f"[Intent] '{query[:50]}' → {intent}")

        if "student" in intent:
            return "student_query"
        return "knowledge_query"

    except Exception as e:
        print(f"[Intent Error] {e}")
        # Simple fallback
        q = query.lower()
        if any(w in q for w in [
            "cgpa", "sgpa", "grade", "marks", "result",
            "topper", "rank", "usn", "pass", "fail",
            "how many students", "students with", "students who"
        ]):
            return "student_query"
        return "knowledge_query"