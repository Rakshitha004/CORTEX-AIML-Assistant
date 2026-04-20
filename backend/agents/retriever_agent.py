from rag.retriever import retrieve_documents


def retriever_agent(state):
    """
    Retrieves relevant documents for knowledge queries
    """

    query = state["query"]

    docs = retrieve_documents(query)

    state["documents"] = docs

    return state