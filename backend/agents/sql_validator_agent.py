import requests
import re
import os

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")

FORBIDDEN_KEYWORDS = ["DROP", "DELETE", "UPDATE", "INSERT", "ALTER", "TRUNCATE", "GRANT", "REVOKE", "EXEC", "EXECUTE", "XP_", "--", ";--"]
VALID_TABLES = ["student_results", "semester_results", "subject_grades"]

def guardrail_check(sql: str):
    sql_upper = sql.upper()

    for keyword in FORBIDDEN_KEYWORDS:
        if keyword in sql_upper:
            raise ValueError(f"Unsafe SQL detected: contains '{keyword}'")

    if not sql_upper.strip().startswith("SELECT"):
        raise ValueError("Only SELECT queries are allowed!")

    tables_in_sql = re.findall(r'FROM\s+(\w+)|JOIN\s+(\w+)', sql_upper)
    for match in tables_in_sql:
        for table in match:
            if table and table.lower() not in VALID_TABLES:
                raise ValueError(f"Invalid table: '{table}'")

    return True


def validate_sql(sql):

    guardrail_check(sql)

    prompt = f"""You are a SQL security expert for a college department chatbot.

The database has these read-only tables:
1. student_results (usn, name, cgpa)
2. semester_results (usn, semester, sgpa)
3. subject_grades (usn, semester, subject_code, subject_name, grade)

Only SELECT queries are allowed.

Check this SQL query for:
1. Unsafe operations (DROP, DELETE, UPDATE, INSERT, ALTER, TRUNCATE)
2. Syntax errors
3. Any malicious or harmful patterns
4. Invalid table names

SQL Query: "{sql}"

Reply with ONLY one of these:
- "SAFE" if the query is valid and safe
- "UNSAFE: reason" if the query is dangerous or invalid

Nothing else."""

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
                "max_tokens": 50
            }
        )

        result = response.json()
        verdict = result["choices"][0]["message"]["content"].strip().upper()

        if verdict.startswith("UNSAFE"):
            raise ValueError(f"Unsafe SQL detected: {verdict}")

    except ValueError:
        raise
    except Exception as e:
        print(f"AI validator failed, guardrails passed: {e}")

    return sql


def explain_sql(sql):
    return "EXPLAIN " + sql