import requests
import os

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")

def select_table(query, intent):
    prompt = f"""You are a database expert for a college department chatbot.

Available tables in the database:
1. "student_results" → usn, name, cgpa — use for overall CGPA, rankings, topper queries
2. "semester_results" → usn, semester, sgpa — use for semester wise SGPA queries
3. "subject_grades" → usn, semester, subject_code, subject_name, grade — use for subject wise grade queries
4. "multiple" → if query needs data from more than one table

User query: "{query}"
Detected intent: "{intent}"

Reply with ONLY the table name. Nothing else.
Example: student_results"""

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
                "max_tokens": 15
            },
            timeout=30
        )
        result = response.json()

        if "choices" not in result:
            raise Exception(f"API error: {result}")

        table = result["choices"][0]["message"]["content"].strip().lower()
        valid_tables = ["student_results", "semester_results", "subject_grades", "multiple"]
        if table in valid_tables:
            return table
        return "student_results"

    except Exception as e:
        print(f"Table agent error: {e}")
        q = query.lower()
        if any(w in q for w in ["grade", "subject", "course"]):
            return "subject_grades"
        elif any(w in q for w in ["semester", "sgpa", "sem"]):
            return "semester_results"
        return "student_results"