def audit_pipeline(query, sql, result):

    audit_data = {
        "query": query,
        "sql_generated": sql,
        "rows_returned": len(result) if result else 0,
        "status": "success"
    }

    return audit_data