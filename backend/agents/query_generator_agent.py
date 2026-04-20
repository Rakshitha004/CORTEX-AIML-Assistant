import os
import requests
import re

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")

VALID_TABLES = ["student_results", "semester_results", "subject_grades"]

def clean_sql(sql: str) -> str:
    # Remove markdown
    sql = sql.replace("```sql", "").replace("```", "").strip()
    # Remove multiple statements - only keep first
    sql = sql.split(";")[0].strip() + ";"
    return sql

def is_safe_sql(sql: str) -> bool:
    sql_upper = sql.upper()
    forbidden = ["DROP", "DELETE", "UPDATE", "INSERT", "ALTER", "TRUNCATE", "GRANT", "REVOKE", "EXEC"]
    for keyword in forbidden:
        if keyword in sql_upper:
            return False
    if not sql_upper.strip().startswith("SELECT"):
        return False
    return True

def generate_sql(query):
    prompt = f"""### Task
Generate a SQL query to answer the following question:
{query}

### Database Schema
CREATE TABLE student_results (
    usn TEXT UNIQUE,
    name TEXT,
    cgpa REAL
);

CREATE TABLE semester_results (
    usn TEXT,
    semester INTEGER,
    sgpa REAL
);

CREATE TABLE subject_grades (
    usn TEXT,
    semester INTEGER,
    subject_code TEXT,
    subject_name TEXT,
    grade TEXT  -- VTU grading: O=10, S=9, A=8, B=7, C=6, D=5, F=0
);

### Rules
- Only return the SQL query, no explanation, no markdown, no backticks
- The SQL must work in PostgreSQL
- USN is a TEXT field, never use EXTRACT or date functions on it
- To filter by batch year (e.g. 2021 batch), use: WHERE usn LIKE '%21AI%'
- ROUND(AVG(cgpa)::numeric, 2) for clean decimal output
- ROUND(AVG(sgpa)::numeric, 2) for clean decimal output
- For subject queries use subject_grades table
- For semester SGPA queries use semester_results table
- For overall CGPA queries use student_results table
- When query needs name + grades, JOIN student_results WITH subject_grades ON usn
- When query needs name + sgpa, JOIN student_results WITH semester_results ON usn
- Semester numbers: 3=3rd sem, 4=4th sem, 5=5th sem, 6=6th sem, 7=7th sem, 8=8th sem
- Only use SELECT statements, never DROP/DELETE/UPDATE/INSERT
- For consecutive semester comparison, use self JOIN on semester_results
- For students who dropped SGPA, compare s1.sgpa > s2.sgpa where s2.semester = s1.semester + 1
- The grade column in subject_grades is TEXT using VTU grading: O, S, A, B, C, D, F
- NEVER use AVG(grade) or ORDER BY grade directly — always convert using this CASE expression:
  CASE grade WHEN 'O' THEN 10 WHEN 'S' THEN 9 WHEN 'A' THEN 8 WHEN 'B' THEN 7 WHEN 'C' THEN 6 WHEN 'D' THEN 5 WHEN 'F' THEN 0 ELSE 0 END
- For counting top performers in a subject, use COUNT(*) WHERE grade IN ('O', 'S')
- For students with backlogs/failures, use WHERE grade = 'F'
- When asked about "average marks" or "average grade" for subjects, use the CASE grade mapping above
- Always label the computed grade point column as avg_grade_point or grade_point for clarity

### Examples
- "who has highest cgpa?" → SELECT name, usn, cgpa FROM student_results ORDER BY cgpa DESC LIMIT 1;
- "top 5 students" → SELECT name, usn, cgpa FROM student_results ORDER BY cgpa DESC LIMIT 5;
- "average cgpa" → SELECT ROUND(AVG(cgpa)::numeric, 2) AS average_cgpa FROM student_results;
- "who topped 5th semester?" → SELECT sr.name, sr.usn, sm.sgpa FROM student_results sr JOIN semester_results sm ON sr.usn = sm.usn WHERE sm.semester = 5 ORDER BY sm.sgpa DESC LIMIT 1;
- "what is Vidya's 6th sem sgpa?" → SELECT sr.name, sm.semester, sm.sgpa FROM student_results sr JOIN semester_results sm ON sr.usn = sm.usn WHERE sr.name ILIKE '%Vidya%' AND sm.semester = 6;
- "what grade did Adithya get in NLP?" → SELECT sr.name, sg.subject_name, sg.grade FROM student_results sr JOIN subject_grades sg ON sr.usn = sg.usn WHERE sr.name ILIKE '%Adithya%' AND sg.subject_name ILIKE '%NLP%';
- "show all grades of Vidya in 5th sem" → SELECT sr.name, sg.subject_name, sg.grade FROM student_results sr JOIN subject_grades sg ON sr.usn = sg.usn WHERE sr.name ILIKE '%Vidya%' AND sg.semester = 5;
- "how many students have cgpa above 9?" → SELECT COUNT(*) FROM student_results WHERE cgpa > 9;
- "average sgpa of 6th semester" → SELECT ROUND(AVG(sgpa)::numeric, 2) AS avg_sgpa FROM semester_results WHERE semester = 6;
- "students whose sgpa dropped" → SELECT sr.name, sr.usn, s1.semester AS from_sem, s2.semester AS to_sem, s1.sgpa AS sgpa_before, s2.sgpa AS sgpa_after FROM semester_results s1 JOIN semester_results s2 ON s1.usn = s2.usn AND s2.semester = s1.semester + 1 JOIN student_results sr ON s1.usn = sr.usn WHERE s2.sgpa < s1.sgpa ORDER BY (s1.sgpa - s2.sgpa) DESC;
- "which 5 subjects have highest average marks?" → SELECT subject_name, ROUND(AVG(CASE grade WHEN 'O' THEN 10 WHEN 'S' THEN 9 WHEN 'A' THEN 8 WHEN 'B' THEN 7 WHEN 'C' THEN 6 WHEN 'D' THEN 5 WHEN 'F' THEN 0 ELSE 0 END)::numeric, 2) AS avg_grade_point FROM subject_grades GROUP BY subject_name ORDER BY avg_grade_point DESC LIMIT 5;
- "which subject has most failures?" → SELECT subject_name, COUNT(*) AS failures FROM subject_grades WHERE grade = 'F' GROUP BY subject_name ORDER BY failures DESC LIMIT 1;
- "how many students have backlogs?" → SELECT COUNT(DISTINCT usn) FROM subject_grades WHERE grade = 'F';
- "students with backlogs" → SELECT DISTINCT sr.name, sr.usn FROM student_results sr JOIN subject_grades sg ON sr.usn = sg.usn WHERE sg.grade = 'F';
- "top performers in a subject?" → SELECT sr.name, sg.subject_name, sg.grade FROM student_results sr JOIN subject_grades sg ON sr.usn = sg.usn WHERE sg.subject_name ILIKE '%NLP%' AND sg.grade IN ('O', 'S') ORDER BY sg.grade;
- "students who passed all subjects in semester 3?" → SELECT sr.name, sr.usn FROM student_results sr WHERE sr.usn NOT IN (SELECT usn FROM subject_grades WHERE semester = 3 AND grade = 'F');
- "compare average cgpa of students with backlogs vs without?" → SELECT 'With backlogs' AS category, ROUND(AVG(cgpa)::numeric, 2) AS avg_cgpa FROM student_results WHERE usn IN (SELECT DISTINCT usn FROM subject_grades WHERE grade = 'F') UNION ALL SELECT 'Without backlogs', ROUND(AVG(cgpa)::numeric, 2) FROM student_results WHERE usn NOT IN (SELECT DISTINCT usn FROM subject_grades WHERE grade = 'F');

### Answer
"""

    try:
        response = requests.post(
            "https://api.together.xyz/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {TOGETHER_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": "Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8",
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0,
                "max_tokens": 300
            },
            timeout=60
        )

        result = response.json()

        if "choices" not in result:
            raise Exception(f"API error: {result}")

        sql = result["choices"][0]["message"]["content"].strip()
        sql = clean_sql(sql)

        if not is_safe_sql(sql):
            print(f"Unsafe SQL generated: {sql}")
            return "SELECT name, usn, cgpa FROM student_results ORDER BY cgpa DESC LIMIT 5;"

        print(f"[SQL Generated] {sql}")
        return sql

    except Exception as e:
        print(f"SQL generation failed: {e}")
        return None