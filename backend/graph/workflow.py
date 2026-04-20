from langgraph.graph import StateGraph, END

from .state import AgentState
from .nodes import (
    audit_node,
    intent_node,
    table_node,
    column_node,
    query_node,
    validator_node,
    execution_node,
    synthesis_node,
    rag_node
)

builder = StateGraph(AgentState)

builder.add_node("intent", intent_node)
builder.add_node("table", table_node)
builder.add_node("column", column_node)
builder.add_node("query", query_node)
builder.add_node("validate", validator_node)
builder.add_node("execute", execution_node)
builder.add_node("rag", rag_node)
builder.add_node("synthesis", synthesis_node)
builder.add_node("audit", audit_node)

builder.set_entry_point("intent")

# ---- Conditional routing after intent ----
def route_by_intent(state):
    if state.get("intent") == "knowledge_query":
        return "rag"
    return "table"

builder.add_conditional_edges("intent", route_by_intent, {
    "rag": "rag",
    "table": "table"
})

# ---- SQL path ----
builder.add_edge("table", "column")
builder.add_edge("column", "query")
builder.add_edge("query", "validate")
builder.add_edge("validate", "execute")
builder.add_edge("execute", "synthesis")

# ---- RAG path ----
builder.add_edge("rag", "synthesis")

# ---- Shared tail ----
builder.add_edge("synthesis", "audit")
builder.add_edge("audit", END)

graph = builder.compile()