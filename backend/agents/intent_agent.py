import requests

TOGETHER_API_KEY = "a60fb67ec58586166da63dfbbc672210cd4d9815a873a1684f60ca22c90e5a62"

def detect_intent(query):
    prompt = f"""You are an intent classifier for a college department chatbot.

The database has ONLY these 3 tables:
1. student_results (usn, name, cgpa) → overall student CGPA and names
2. semester_results (usn, semester, sgpa) → semester wise SGPA
3. subject_grades (usn, semester, subject_code, subject_name, grade) → subject wise grades

Classify the user query into ONE of these two intents:
- "student_query" → ONLY if the query is about individual student CGPA, marks, results, rankings, USN, semester SGPA, subject grades
- "knowledge_query" → if the query is about ANY of the following: syllabus, timetable, courses, academic rules, faculty, notices, department info, MOU, internships offered by companies, placements, research, events, workshops, labs, publications, patents, funding, scholarships, admission, fees, facilities, vision, mission, achievements, clubs, activities, hackathons, companies, collaborations, skill development

Important rules:
- "Which companies offered internships?" → knowledge_query (about company info, not student data)
- "How many students did internships?" → student_query (about student count)
- "What is the MOU with Digitoad?" → knowledge_query
- "List all faculty members" → knowledge_query
- "Who has highest CGPA?" → student_query
- "What are the research areas?" → knowledge_query
- "Which companies came for placement?" → knowledge_query
- "How many students got placed?" → student_query

User query: "{query}"

Reply with ONLY one of these two words: student_query OR knowledge_query. Nothing else."""

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
        if "student" in intent:
            return "student_query"
        return "knowledge_query"

    except Exception as e:
        print(f"Intent agent error: {e}")
        q = query.lower()
        if any(w in q for w in ["cgpa", "grade", "marks", "sgpa", "result", "topper", "rank", "usn"]):
            return "student_query"
        # Default to knowledge_query for everything else
        return "knowledge_query"