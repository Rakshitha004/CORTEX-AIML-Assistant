import requests
import json

URL = "http://127.0.0.1:8000/query"

print("\nAIML Department Digital Assistant")
print("Type 'exit' to quit\n")

while True:

    user_query = input("Ask a query about results: ")

    if user_query.lower() == "exit":
        break

    response = requests.post(URL, json={"query": user_query})

    if response.status_code != 200:
        print("\n❌ Backend Error:", response.text)
        continue

    data = response.json()

    print("\n================ PIPELINE =================\n")

    print("User Query:")
    print(data.get("query"))

    print("\nIntent Agent:")
    print(data.get("intent"))

    print("\nTable Selection Agent:")
    print(data.get("table"))

    print("\nColumn Pruning Agent:")
    print(data.get("columns"))

    print("\nQuery Generation Agent (SQL):")
    print(data.get("sql"))

    print("\nSQL Validator Agent:")
    print(data.get("validated_sql"))

    print("\nExecution Agent Result:")
    print(json.dumps(data.get("result"), indent=2))

    print("\nSynthesis Agent:")
    print(data.get("answer"))

    print("\nAudit & Feedback Agent:")
    print(json.dumps(data.get("audit"), indent=2))

    print("\n===========================================\n")