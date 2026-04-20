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

builder.add_node("step_intent", intent_node)
builder.add_node("step_table", table_node)
builder.add_node("step_column", column_node)
builder.add_node("step_query", query_node)
builder.add_node("step_validate", validator_node)
builder.add_node("step_execute", execution_node)
builder.add_node("step_rag", rag_node)
builder.add_node("step_synthesis", synthesis_node)
builder.add_node("step_audit", audit_node)

builder.set_entry_point("step_intent")

# ---- Conditional routing after intent ----
def route_by_intent(state):
    if state.get("intent") == "knowledge_query":
        return "step_rag"
    return "step_table"

builder.add_conditional_edges("step_intent", route_by_intent, {
    "step_rag": "step_rag",
    "step_table": "step_table"
})

# ---- SQL path ----
builder.add_edge("step_table", "step_column")
builder.add_edge("step_column", "step_query")
builder.add_edge("step_query", "step_validate")
builder.add_edge("step_validate", "step_execute")
builder.add_edge("step_execute", "step_synthesis")

# ---- RAG path ----
builder.add_edge("step_rag", "step_synthesis")

# ---- Shared tail ----
builder.add_edge("step_synthesis", "step_audit")
builder.add_edge("step_audit", END)

graph = builder.compile()