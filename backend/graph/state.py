from typing import TypedDict, List, Optional, Any


class AgentState(TypedDict):

    query: str

    intent: Optional[str]

    table: Optional[str]

    columns: Optional[List[str]]

    sql: Optional[str]

    safe_sql: Optional[str]

    result: Optional[list]

    answer: Optional[str]

    # Added fields
    db: Optional[Any]
    validated_sql: Optional[str]
    retrieved_docs: Optional[list]
    sources: Optional[list]
    grounding_score: Optional[float]
    confidence: Optional[str]
    rag_metrics_partial: Optional[dict]
    sql_metrics: Optional[dict]
    rows_returned: Optional[int]
    audit: Optional[str]