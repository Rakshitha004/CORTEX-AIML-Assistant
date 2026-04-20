from backend.agents.intent_agent import detect_intent
from backend.agents.table_agent import select_table
from backend.agents.column_pruning_agent import prune_columns
from backend.agents.query_generator_agent import generate_sql
from backend.agents.sql_validator_agent import validate_sql
from backend.agents.synthesis_agent import format_response
from backend.agents.audit_feedback_agent import audit_pipeline
from backend.database.db_connection import run_sql
from backend.rag.retriver import retrieve_documents
from datetime import datetime
import time
import csv
import os
from pymongo import MongoClient

# ── Direct MongoDB connection for metrics ──────────────────────────────────────
try:
    _mongo_url = os.getenv("MONGO_URL", "")
    _client = MongoClient(_mongo_url, tlsAllowInvalidCertificates=True, serverSelectionTimeoutMS=5000)
    _db = _client["cortex"]
    metrics_col = _db["metrics"]
    print("[Nodes] MongoDB metrics connection established!")
except Exception as e:
    metrics_col = None
    print(f"[Nodes] MongoDB metrics connection failed: {e}")

METRICS_CSV = "cortex_metrics.csv"

def save_metrics(db, metrics: dict):
    # Always use the direct metrics_col connection
    target_db = metrics_col if metrics_col is not None else db
    try:
        if target_db is not None:
            target_db.insert_one(metrics)
            print(f"[Metrics] Saved to MongoDB!")
    except Exception as e:
        print(f"[Metrics] MongoDB failed: {e}")

    try:
        file_exists = os.path.isfile(METRICS_CSV)
        fieldnames = [
            "timestamp", "pipeline", "query", "query_complexity",
            "chunks_retrieved", "sources_used", "source_diversity",
            "avg_chunk_relevance_score", "grounding_score", "confidence",
            "answer_length", "context_length", "answer_length_ratio",
            "execution_time_ms", "success", "error",
            "sql_generated", "sql_complexity", "sql_valid",
            "rows_returned", "empty_result", "result_density",
        ]
        with open(METRICS_CSV, "a", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
            if not file_exists:
                writer.writeheader()
            row = {k: str(v) if isinstance(v, list) else v for k, v in metrics.items()}
            row["timestamp"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            writer.writerow(row)
        print(f"[Metrics] Saved to CSV!")
    except Exception as e:
        print(f"[Metrics] CSV failed: {e}")


def extract_sources(docs: list) -> list:
    return list(set([
        doc.metadata.get("doc_name", "Unknown")
        for doc in docs
        if doc.metadata.get("doc_name", "Unknown") != "Unknown"
    ]))


def get_query_complexity(query: str) -> str:
    words = len(query.split())
    if words <= 5:
        return "Simple"
    elif words <= 12:
        return "Medium"
    else:
        return "Complex"


def get_sql_complexity(sql: str) -> str:
    if not sql:
        return "Unknown"
    sql_upper = sql.upper()
    if "JOIN" in sql_upper:
        return "Complex"
    elif any(kw in sql_upper for kw in ["GROUP BY", "ORDER BY", "AVG", "COUNT", "SUM", "MAX", "MIN"]):
        return "Medium"
    else:
        return "Simple"


def get_avg_chunk_score(docs: list) -> float:
    scores = [doc.metadata.get("score", 0.0) for doc in docs if doc.metadata.get("score")]
    return round(sum(scores) / len(scores), 3) if scores else 0.0


def get_answer_length_ratio(answer: str, context: str) -> float:
    if not context:
        return 0.0
    return round(len(answer) / max(len(context), 1), 3)


def intent_node(state):
    query = state["query"]
    intent = detect_intent(query)
    state["intent"] = intent
    return state


def table_node(state):
    query = state["query"]
    intent = state["intent"]
    table = select_table(query, intent)
    state["table"] = table
    return state


def column_node(state):
    query = state["query"]
    table = state["table"]
    columns = prune_columns(query, table)
    state["columns"] = columns
    return state


def query_node(state):
    query = state["query"]
    sql = generate_sql(query)
    state["sql"] = sql
    return state


def validator_node(state):
    sql = state["sql"]
    if not sql:
        state["validated_sql"] = None
        state["validation"] = "SQL generation failed"
        return state
    validated_sql = validate_sql(sql)
    state["validated_sql"] = validated_sql
    state["validation"] = "SQL validated successfully"
    return state


def execution_node(state):
    intent = state.get("intent")
    db = state.get("db")
    start_time = time.time()

    if intent == "student_query":
        sql = state.get("validated_sql") or state.get("sql")

        if not sql:
            state["result"] = []
            state["rows_returned"] = 0
            state["answer"] = "I could not generate a valid SQL query for your question. Please rephrase and try again."
            return state

        sql_valid = bool(sql and sql.strip().upper().startswith("SELECT"))
        sql_complexity = get_sql_complexity(sql)
        query_complexity = get_query_complexity(state.get("query", ""))

        try:
            result = run_sql(sql)
            rows_returned = len(result)
            success = True
            error_msg = None
        except Exception as e:
            result = []
            rows_returned = 0
            success = False
            error_msg = str(e)

        execution_time_ms = round((time.time() - start_time) * 1000, 2)
        empty_result = rows_returned == 0
        state["result"] = result
        state["rows_returned"] = rows_returned

        sql_metrics = {
            "pipeline": "SQL",
            "query": state.get("query"),
            "email": state.get("email", ""),
            "query_complexity": query_complexity,
            "sql_generated": sql,
            "sql_complexity": sql_complexity,
            "sql_valid": sql_valid,
            "rows_returned": rows_returned,
            "empty_result": empty_result,
            "execution_time_ms": execution_time_ms,
            "success": bool(success),
            "error": error_msg,
            "timestamp": datetime.now(),
        }
        state["sql_metrics"] = sql_metrics
        save_metrics(db, sql_metrics)
        print(f"[SQL Metrics] rows={rows_returned}, time={execution_time_ms}ms, success={success}, complexity={sql_complexity}, empty={empty_result}")

    elif intent == "knowledge_query":
        query = state["query"]
        query_complexity = get_query_complexity(query)

        try:
            docs = retrieve_documents(query)
            context = "\n".join([doc.page_content for doc in docs])
            sources = extract_sources(docs)
            source_diversity = len(sources)
            avg_chunk_score = get_avg_chunk_score(docs)
            success = True
            error_msg = None
        except Exception as e:
            docs = []
            context = ""
            sources = []
            source_diversity = 0
            avg_chunk_score = 0.0
            success = False
            error_msg = str(e)

        execution_time_ms = round((time.time() - start_time) * 1000, 2)
        state["result"] = context
        state["retrieved_docs"] = docs
        state["sources"] = sources

        rag_metrics_partial = {
            "pipeline": "RAG",
            "query": query,
            "email": state.get("email", ""),
            "query_complexity": query_complexity,
            "chunks_retrieved": len(docs),
            "sources_used": sources,
            "source_diversity": source_diversity,
            "avg_chunk_relevance_score": avg_chunk_score,
            "context_length": len(context),
            "execution_time_ms": execution_time_ms,
            "success": success,
            "error": error_msg,
            "timestamp": datetime.now(),
        }
        state["rag_metrics_partial"] = rag_metrics_partial
        print(f"[RAG Metrics] chunks={len(docs)}, sources={source_diversity}, avg_score={avg_chunk_score}, time={execution_time_ms}ms")

    return state


def synthesis_node(state):
    query = state.get("query")
    result = state.get("result")
    db = state.get("db")

    if result is None:
        return {**state, "answer": "I could not generate a valid SQL query for your question. Please rephrase and try again.", "sources": []}

    if isinstance(result, list) and len(result) == 0:
        return {**state, "answer": "No records found for your query.", "sources": []}

    answer, grounding_score = format_response(query, result)

    if state.get("intent") == "knowledge_query":
        context = state.get("result", "")
        sources = state.get("sources", [])
        answer_length_ratio = get_answer_length_ratio(answer, context)

        if grounding_score >= 0.6:
            confidence = "High"
        elif grounding_score >= 0.3:
            confidence = "Medium"
        else:
            confidence = "Low"

        rag_metrics = state.get("rag_metrics_partial", {})
        rag_metrics.update({
            "answer_length": len(answer),
            "answer_length_ratio": answer_length_ratio,
            "grounding_score": grounding_score,
            "confidence": confidence,
        })
        save_metrics(db, rag_metrics)
        print(f"[RAG Grounding] score={grounding_score}, confidence={confidence}, compression={answer_length_ratio}")

        return {
            **state,
            "answer": answer,
            "sources": sources,
            "grounding_score": grounding_score,
            "confidence": confidence,
        }

    return {
        **state,
        "answer": answer,
        "grounding_score": grounding_score,
    }


def audit_node(state):
    query = state.get("query")
    sql = state.get("validated_sql")
    result = state.get("result")
    audit = audit_pipeline(query, sql, result)
    state["audit"] = audit
    return state


def rag_node(state):
    query = state["query"]
    db = state.get("db")
    start_time = time.time()

    docs = retrieve_documents(query)

    seen = set()
    unique_docs = []
    for doc in docs:
        fingerprint = doc.page_content.strip()[:300]
        if fingerprint not in seen:
            seen.add(fingerprint)
            unique_docs.append(doc)

    context = "\n\n".join([doc.page_content for doc in unique_docs])
    sources = extract_sources(unique_docs)
    source_diversity = len(sources)
    avg_chunk_score = get_avg_chunk_score(unique_docs)
    execution_time_ms = round((time.time() - start_time) * 1000, 2)

    print(f"RAG context length: {len(context)} chars, {len(unique_docs)} unique docs")
    print(f"Sources: {sources}")

    rag_metrics_partial = {
        "pipeline": "RAG",
        "query": query,
        "email": state.get("email", ""),
        "query_complexity": get_query_complexity(query),
        "chunks_retrieved": len(unique_docs),
        "sources_used": sources,
        "source_diversity": source_diversity,
        "avg_chunk_relevance_score": avg_chunk_score,
        "context_length": len(context),
        "execution_time_ms": execution_time_ms,
        "success": True,
        "timestamp": datetime.now(),
    }
    state["rag_metrics_partial"] = rag_metrics_partial
    state["result"] = context
    state["retrieved_docs"] = unique_docs
    state["sources"] = sources
    return state