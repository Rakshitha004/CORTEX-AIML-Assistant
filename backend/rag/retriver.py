import sys
import numpy as np
from pathlib import Path
from rank_bm25 import BM25Okapi
from sentence_transformers import CrossEncoder
from functools import lru_cache
import hashlib

RAG_PROJECT_PATH = Path("C:/Dev/AIML-Dept-Digital-Assistant/aiml-department-digital-assistant")
sys.path.insert(0, str(RAG_PROJECT_PATH))

# ─── Cross-Encoder Reranker (loaded once) ─────────────────
reranker = CrossEncoder("cross-encoder/ms-marco-MiniLM-L-6-v2")

# ─── In-Memory Query Cache ─────────────────────────────────
_query_cache = {}

class Document:
    def __init__(self, page_content: str, metadata: dict = None):
        self.page_content = page_content
        self.metadata = metadata or {}


def tokenize(text: str):
    return text.lower().split()


def get_cache_key(query: str) -> str:
    return hashlib.md5(query.lower().strip().encode()).hexdigest()


# ─── Recall@K Metric ──────────────────────────────────────
def recall_at_k(retrieved: list, relevant: list, k: int = 10) -> float:
    if not relevant:
        return 0.0
    hits = len(set(retrieved[:k]) & set(relevant))
    return round(hits / len(relevant), 2)


# ─── MRR Metric ───────────────────────────────────────────
def mean_reciprocal_rank(retrieved: list, relevant: list) -> float:
    for rank, doc_id in enumerate(retrieved, 1):
        if doc_id in relevant:
            return round(1 / rank, 2)
    return 0.0


# ─── RRF Fusion ───────────────────────────────────────────
def rrf_fusion(scores_list: list, k: int = 60) -> dict:
    fused = {}
    for scores in scores_list:
        for rank, idx in enumerate(np.argsort(scores)[::-1]):
            fused[idx] = fused.get(idx, 0) + 1 / (rank + k)
    return fused


def hybrid_search(query: str, top_k: int = 20) -> list:
    try:
        from rag.embeddings.generator import get_embedding_generator
        from rag.vector_store.faiss_store import get_vector_store

        vector_store = get_vector_store()
        all_docs = vector_store.metadata

        if not all_docs:
            return []

        contents = [doc.get("content", "") for doc in all_docs]

        # ── BM25 ──────────────────────────────────────────
        tokenized_corpus = [tokenize(c) for c in contents]
        bm25 = BM25Okapi(tokenized_corpus)
        bm25_scores = bm25.get_scores(tokenize(query))
        bm25_max = bm25_scores.max()
        if bm25_max > 0:
            bm25_scores = bm25_scores / bm25_max

        # ── FAISS ─────────────────────────────────────────
        import faiss
        embedding_gen = get_embedding_generator()
        query_embedding = embedding_gen.encode(query)
        if len(query_embedding) == 0:
            return []

        query_vec = np.array([query_embedding[0]]).astype("float32")
        distances, indices = vector_store.index.search(query_vec, len(all_docs))

        faiss_scores = np.zeros(len(all_docs))
        max_dist = distances[0].max()
        if max_dist > 0:
            for dist, idx in zip(distances[0], indices[0]):
                if idx < len(all_docs):
                    faiss_scores[idx] = 1 - (dist / max_dist)

        # ── RRF Fusion ────────────────────────────────────
        fused = rrf_fusion([bm25_scores, faiss_scores])
        combined_scores = np.zeros(len(all_docs))
        for idx, score in fused.items():
            combined_scores[idx] = score

        # ── Smart Query-Based Boosting ────────────────────
        query_lower = query.lower()

        for i, doc in enumerate(all_docs):
            doc_name = doc.get("doc_name", "").lower()
            content = doc.get("content", "").lower()

            if any(kw in query_lower for kw in ["faculty", "professor", "staff", "lecturer", "who are", "list all", "hod", "head"]):
                if "faculty" in doc_name:
                    combined_scores[i] *= 2.0
                    if "faculty name" in content or "designation" in content:
                        combined_scores[i] *= 3.0
            elif any(kw in query_lower for kw in ["research", "publication", "paper", "journal", "project"]):
                if "research" in doc_name:
                    combined_scores[i] *= 2.0
            else:
                if any(kw in doc_name for kw in ["department", "vision", "mission", "aiml"]):
                    combined_scores[i] *= 1.5

        # ── Get top candidates for reranking ─────────────
        top_indices = np.argsort(combined_scores)[::-1][:20]

        candidates = []
        for idx in top_indices:
            if combined_scores[idx] > 0.0:
                candidates.append({
                    "content": contents[idx],
                    "doc_name": all_docs[idx].get("doc_name", ""),
                    "score": float(combined_scores[idx]),
                    "idx": int(idx)
                })

        if not candidates:
            return []

        # ── Cross-Encoder Reranking ───────────────────────
        pairs = [(query, c["content"][:512]) for c in candidates]
        rerank_scores = reranker.predict(pairs)
        ranked = sorted(zip(rerank_scores, candidates), key=lambda x: x[0], reverse=True)

        results = []
        for score, doc in ranked[:top_k]:
            results.append({
                "content": doc["content"],
                "doc_name": doc["doc_name"],
                "score": float(score),
            })

        return results

    except Exception as e:
        print(f"Hybrid search error: {e}")
        return []


def retrieve_documents(query: str, top_k: int = 10) -> list:
    try:
        # ── Check Cache ───────────────────────────────────
        cache_key = get_cache_key(query)
        if cache_key in _query_cache:
            print(f"[Cache HIT] Query: {query[:50]}")
            return _query_cache[cache_key]

        query_lower = query.lower()

        # ── Dynamic top_k ─────────────────────────────────
        if any(kw in query_lower for kw in ["faculty", "professor", "staff", "hod", "head of department", "lecturer", "members", "who are", "list all"]):
            top_k = 20
        elif any(kw in query_lower for kw in ["research", "publication", "paper", "project"]):
            top_k = 15
        else:
            top_k = 10

        results = hybrid_search(query, top_k=top_k)

        if not results:
            return [Document("No relevant documents found.")]

        print(f"\n=== Retrieved {len(results)} chunks after reranking ===")
        for i, r in enumerate(results[:5]):
            print(f"[{i+1}] doc: {r.get('doc_name')} | rerank_score: {r.get('score'):.3f} | preview: {r.get('content','')[:80]}")

        documents = []
        for result in results:
            content = result.get("content", "")
            metadata = {
                "doc_name": result.get("doc_name", ""),
                "score": result.get("score", 0.0)
            }
            if content:
                documents.append(Document(content, metadata))

        final_docs = documents if documents else [Document("No relevant content found.")]

        # ── Recall@K and MRR (self-eval) ──────────────────
        retrieved_names = [r.get("doc_name", "") for r in results]
        unique_names = list(set(retrieved_names))
        recall = recall_at_k(retrieved_names, unique_names, k=top_k)
        mrr = mean_reciprocal_rank(retrieved_names, unique_names)
        print(f"[Eval] Recall@{top_k}: {recall} | MRR: {mrr}")

        # ── Save to Cache ──────────────────────────────────
        _query_cache[cache_key] = final_docs
        print(f"[Cache SET] Query cached: {query[:50]}")

        return final_docs

    except Exception as err:
        print(f"retrieve_documents error: {err}")
        return [Document(f"RAG retrieval error: {str(err)}")]