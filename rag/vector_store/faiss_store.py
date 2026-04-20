"""
Pinecone vector store — drop-in replacement for FAISS.
Same interface as before so retriever.py needs no changes.
"""

import os
import numpy as np
from typing import List, Dict, Any, Optional
from utils.logger import logger

PINECONE_API_KEY = os.getenv("PINECONE_API_KEY", "")
PINECONE_INDEX_NAME = "cortex-rag"


class FAISSVectorStore:
    """
    Pinecone-backed vector store with the same interface as the old FAISS store.
    retriever.py uses vector_store.metadata and vector_store.index.search()
    so we emulate both.
    """

    def __init__(self, embedding_dim: int = 1024):
        self.embedding_dim = embedding_dim
        self.metadata: List[Dict[str, Any]] = []
        self._pc = None
        self._index = None
        self.index = self  # retriver.py calls vector_store.index.search()
        self._connect()
        self._load_metadata()

    # ── Connect to Pinecone ───────────────────────────────────────────────────
    def _connect(self):
        try:
            from pinecone import Pinecone
            self._pc = Pinecone(api_key=PINECONE_API_KEY)
            self._index = self._pc.Index(PINECONE_INDEX_NAME)
            stats = self._index.describe_index_stats()
            total = stats.get("total_vector_count", 0)
            logger.info(f"[Pinecone] Connected to '{PINECONE_INDEX_NAME}' — {total} vectors")
            print(f"[Pinecone] Connected! Total vectors: {total}")
        except Exception as e:
            logger.error(f"[Pinecone] Connection failed: {e}")
            print(f"[Pinecone] Connection failed: {e}")
            self._index = None

    # ── Load all metadata from Pinecone into memory ───────────────────────────
    def _load_metadata(self):
        """
        Fetch all vectors from Pinecone and rebuild self.metadata list.
        This keeps compatibility with BM25 in retriever.py which needs all docs.
        """
        try:
            if self._index is None:
                return
            stats = self._index.describe_index_stats()
            total = stats.get("total_vector_count", 0)
            if total == 0:
                self.metadata = []
                return

            # Fetch in batches using list + fetch
            all_ids = []
            # Use list endpoint to get all IDs
            try:
                for id_batch in self._index.list(limit=100):
                    all_ids.extend(id_batch)
            except Exception:
                # Fallback: if list not supported, metadata stays empty
                self.metadata = []
                return

            if not all_ids:
                self.metadata = []
                return

            # Fetch vectors + metadata in batches of 100
            self.metadata = []
            batch_size = 100
            for i in range(0, len(all_ids), batch_size):
                batch_ids = all_ids[i:i + batch_size]
                fetch_result = self._index.fetch(ids=batch_ids)
                vectors = fetch_result.get("vectors", {})
                for vid, vdata in vectors.items():
                    meta = vdata.get("metadata", {})
                    self.metadata.append({
                        "id": vid,
                        "content": meta.get("content", ""),
                        "doc_name": meta.get("doc_name", ""),
                        "length": meta.get("length", 0),
                    })

            logger.info(f"[Pinecone] Loaded {len(self.metadata)} metadata entries")
            print(f"[Pinecone] Loaded {len(self.metadata)} docs into memory")

        except Exception as e:
            logger.error(f"[Pinecone] Failed to load metadata: {e}")
            self.metadata = []

    # ── FAISS-compatible search method ────────────────────────────────────────
    def search(self, query_vec: np.ndarray, top_k: int) -> tuple:
        """
        Emulates faiss.index.search(query_vec, top_k)
        Returns (distances, indices) just like FAISS.
        """
        try:
            if self._index is None:
                return np.array([[]] ), np.array([[]])

            query_list = query_vec[0].tolist()
            results = self._index.query(
                vector=query_list,
                top_k=min(top_k, max(1, len(self.metadata))),
                include_metadata=True
            )

            matches = results.get("matches", [])
            if not matches:
                return np.array([[0.0]]), np.array([[-1]])

            # Map Pinecone IDs back to metadata indices
            id_to_idx = {m.get("id", ""): i for i, m in enumerate(self.metadata)}

            distances = []
            indices = []
            for match in matches:
                mid = match.get("id", "")
                score = match.get("score", 0.0)
                # Convert cosine similarity to distance (lower = better, like FAISS L2)
                dist = 1.0 - score
                idx = id_to_idx.get(mid, -1)
                distances.append(dist)
                indices.append(idx)

            return np.array([distances]), np.array([indices])

        except Exception as e:
            logger.error(f"[Pinecone] Search failed: {e}")
            return np.array([[0.0]]), np.array([[-1]])

    # ── ntotal property (used in retriever) ──────────────────────────────────
    @property
    def ntotal(self) -> int:
        try:
            if self._index is None:
                return 0
            stats = self._index.describe_index_stats()
            return stats.get("total_vector_count", 0)
        except Exception:
            return len(self.metadata)

    # ── Add embeddings ────────────────────────────────────────────────────────
    def add_embeddings(self, embeddings: np.ndarray, metadata: List[Dict[str, Any]]) -> bool:
        try:
            if self._index is None:
                return False

            vectors = []
            for i, (emb, meta) in enumerate(zip(embeddings, metadata)):
                vid = meta.get("id", f"vec_{len(self.metadata) + i}")
                vectors.append({
                    "id": str(vid),
                    "values": emb.tolist(),
                    "metadata": {
                        "content": meta.get("content", ""),
                        "doc_name": meta.get("doc_name", ""),
                        "length": meta.get("length", 0),
                    }
                })
                self.metadata.append({
                    "id": str(vid),
                    "content": meta.get("content", ""),
                    "doc_name": meta.get("doc_name", ""),
                    "length": meta.get("length", 0),
                })

            # Upsert in batches of 100
            batch_size = 100
            for i in range(0, len(vectors), batch_size):
                self._index.upsert(vectors=vectors[i:i + batch_size])

            logger.info(f"[Pinecone] Upserted {len(vectors)} vectors")
            print(f"[Pinecone] Upserted {len(vectors)} vectors successfully!")
            return True

        except Exception as e:
            logger.error(f"[Pinecone] Failed to add embeddings: {e}")
            print(f"[Pinecone] Failed to add embeddings: {e}")
            return False

    # ── Save (no-op for Pinecone — it auto-saves) ─────────────────────────────
    def save(self) -> bool:
        logger.info("[Pinecone] Save called — Pinecone auto-persists, no action needed")
        print("[Pinecone] Auto-saved to cloud!")
        return True

    # ── Load (reload metadata from Pinecone) ─────────────────────────────────
    def load(self) -> bool:
        self._load_metadata()
        return True

    def get_stats(self) -> Dict[str, Any]:
        return {
            "total_vectors": self.ntotal,
            "embedding_dim": self.embedding_dim,
            "metadata_count": len(self.metadata),
            "backend": "Pinecone",
            "index_name": PINECONE_INDEX_NAME,
        }

    def clear(self):
        try:
            if self._index:
                self._index.delete(delete_all=True)
                self.metadata = []
                logger.info("[Pinecone] Index cleared")
        except Exception as e:
            logger.error(f"[Pinecone] Clear failed: {e}")


# ── Global instance ───────────────────────────────────────────────────────────
_vector_store: Optional[FAISSVectorStore] = None


def get_vector_store(embedding_dim: int = 1024) -> FAISSVectorStore:
    global _vector_store
    if _vector_store is None:
        _vector_store = FAISSVectorStore(embedding_dim)
    return _vector_store