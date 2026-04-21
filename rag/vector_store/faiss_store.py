"""
Pinecone vector store — drop-in replacement for FAISS.
Same interface as before so retriever.py needs no changes.
"""

import os
import numpy as np
from typing import List, Dict, Any, Optional
from utils.logger import logger

PINECONE_INDEX_NAME = "cortex-rag"


class FAISSVectorStore:
    def __init__(self, embedding_dim: int = 1024):
        self.embedding_dim = embedding_dim
        self.metadata: List[Dict[str, Any]] = []
        self._pc = None
        self._index = None
        self.index = self
        self._connect()
        self._load_metadata()

    def _connect(self):
        try:
            from pinecone import Pinecone
            api_key = os.getenv("PINECONE_API_KEY", "")
            print(f"[Pinecone] API key found: {bool(api_key)}")
            if not api_key:
                raise ValueError("PINECONE_API_KEY is empty!")
            self._pc = Pinecone(api_key=api_key)
            self._index = self._pc.Index(PINECONE_INDEX_NAME)
            stats = self._index.describe_index_stats()
            total = stats.get("total_vector_count", 0)
            logger.info(f"[Pinecone] Connected to '{PINECONE_INDEX_NAME}' — {total} vectors")
            print(f"[Pinecone] Connected! Total vectors: {total}")
        except Exception as e:
            logger.error(f"[Pinecone] Connection failed: {e}")
            print(f"[Pinecone] Connection failed: {e}")
            self._index = None

    def _load_metadata(self):
        try:
            if self._index is None:
                return
            stats = self._index.describe_index_stats()
            total = stats.get("total_vector_count", 0)
            if total == 0:
                self.metadata = []
                return

            all_ids = []
            try:
                for id_batch in self._index.list(limit=100):
                    all_ids.extend(id_batch)
            except Exception:
                self.metadata = []
                return

            if not all_ids:
                self.metadata = []
                return

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

    def search(self, query_vec: np.ndarray, top_k: int) -> tuple:
        try:
            # ── Reconnect if not connected ────────────────────────────────
            if self._index is None:
                self._connect()

            # ── Reload metadata if empty ──────────────────────────────────
            if not self.metadata:
                print("[Pinecone] Metadata empty, reloading...")
                self._load_metadata()

            if self._index is None:
                return np.array([[0.0]]), np.array([[-1]])

            query_list = query_vec[0].tolist()
            results = self._index.query(
                vector=query_list,
                top_k=min(top_k, max(1, self.ntotal)),
                include_metadata=True
            )

            matches = results.get("matches", [])
            if not matches:
                return np.array([[0.0]]), np.array([[-1]])

            id_to_idx = {m.get("id", ""): i for i, m in enumerate(self.metadata)}

            distances = []
            indices = []
            for match in matches:
                mid = match.get("id", "")
                score = match.get("score", 0.0)
                dist = 1.0 - score

                # If id not in metadata, add it dynamically
                if mid not in id_to_idx:
                    meta = match.get("metadata", {})
                    new_idx = len(self.metadata)
                    self.metadata.append({
                        "id": mid,
                        "content": meta.get("content", ""),
                        "doc_name": meta.get("doc_name", ""),
                        "length": meta.get("length", 0),
                    })
                    id_to_idx[mid] = new_idx

                idx = id_to_idx.get(mid, -1)
                distances.append(dist)
                indices.append(idx)

            return np.array([distances]), np.array([indices])

        except Exception as e:
            logger.error(f"[Pinecone] Search failed: {e}")
            return np.array([[0.0]]), np.array([[-1]])

    @property
    def ntotal(self) -> int:
        try:
            if self._index is None:
                return 0
            stats = self._index.describe_index_stats()
            return stats.get("total_vector_count", 0)
        except Exception:
            return len(self.metadata)

    def add_embeddings(self, embeddings: np.ndarray, metadata: List[Dict[str, Any]]) -> bool:
        try:
            if self._index is None:
                print("[Pinecone] Trying lazy connect...")
                self._connect()
                self._load_metadata()

            if self._index is None:
                print("[Pinecone] Cannot add embeddings — not connected!")
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

    def save(self) -> bool:
        logger.info("[Pinecone] Save called — Pinecone auto-persists, no action needed")
        print("[Pinecone] Auto-saved to cloud!")
        return True

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


_vector_store: Optional[FAISSVectorStore] = None


def get_vector_store(embedding_dim: int = 1024) -> FAISSVectorStore:
    global _vector_store
    if _vector_store is None or _vector_store._index is None:
        _vector_store = FAISSVectorStore(embedding_dim)
    return _vector_store