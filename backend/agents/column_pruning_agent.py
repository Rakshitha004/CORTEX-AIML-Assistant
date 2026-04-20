import requests
import os

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")

def prune_columns(query: str, table: str = None):

    table_columns = {
        "student_results": ["usn", "name", "cgpa"],
        "semester_results": ["usn", "semester", "sgpa"],
        "subject_grades": ["usn", "semester", "subject_code", "subject_name", "grade"],
        "multiple": ["usn", "name", "cgpa", "semester", "sgpa", "subject_name", "grade"]
    }

    available_columns = table_columns.get(table, ["usn", "name", "cgpa"])

    prompt = f"""You are a database expert for a college department chatbot.

Table: {table}
Available columns: {", ".join(available_columns)}

User query: "{query}"

Which columns are needed to answer this query?
Reply with ONLY a comma-separated list of column names from the available columns. Nothing else.
Example: name,cgpa
Example: usn,name,semester,sgpa"""

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
            "max_tokens": 30
        }
    )

    result = response.json()
    raw = result["choices"][0]["message"]["content"].strip().lower()

    all_valid = ["usn", "name", "cgpa", "semester", "sgpa", "subject_code", "subject_name", "grade", "sl_no"]
    columns = [col.strip() for col in raw.split(",") if col.strip() in all_valid]

    if not columns:
        if table == "semester_results":
            columns = ["usn", "semester", "sgpa"]
        elif table == "subject_grades":
            columns = ["usn", "subject_name", "grade"]
        else:
            columns = ["name", "cgpa"]

    return columns