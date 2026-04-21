"""
Pinecone vector store — drop-in replacement for FAISS.
Same interface as before so retriever.py needs no changes.
"""

import os
import time
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

                # Handle both object and dict response from Pinecone SDK
                if hasattr(fetch_result, 'vectors'):
                    vectors = fetch_result.vectors or {}
                else:
                    vectors = fetch_result.get("vectors", {})

                for vid, vdata in vectors.items():
                    # Handle both object and dict metadata
                    if hasattr(vdata, 'metadata'):
                        meta = vdata.metadata or {}
                    else:
                        meta = vdata.get("metadata", {})

                    # Handle both object and dict meta fields
                    if hasattr(meta, 'get'):
                        content = meta.get("content", "")
                        doc_name = meta.get("doc_name", "")
                        length = meta.get("length", 0)
                    else:
                        content = getattr(meta, 'content', "")
                        doc_name = getattr(meta, 'doc_name', "")
                        length = getattr(meta, 'length', 0)

                    self.metadata.append({
                        "id": vid,
                        "content": content,
                        "doc_name": doc_name,
                        "length": length,
                    })

            logger.info(f"[Pinecone] Loaded {len(self.metadata)} metadata entries")
            print(f"[Pinecone] Loaded {len(self.metadata)} docs into memory")

        except Exception as e:
            logger.error(f"[Pinecone] Failed to load metadata: {e}")
            self.metadata = []

    def search(self, query_vec: np.ndarray, top_k: int) -> tuple:
        try:
            if self._index is None:
                self._connect()

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

            # Handle both object and dict response
            if hasattr(results, 'matches'):
                matches = results.matches or []
            else:
                matches = results.get("matches", [])

            if not matches:
                return np.array([[0.0]]), np.array([[-1]])

            id_to_idx = {m.get("id", "") if hasattr(m, 'get') else getattr(m, 'id', ""): i
                        for i, m in enumerate(self.metadata)}

            distances = []
            indices = []
            for match in matches:
                if hasattr(match, 'id'):
                    mid = match.id or ""
                    score = match.score or 0.0
                    meta = match.metadata or {}
                else:
                    mid = match.get("id", "")
                    score = match.get("score", 0.0)
                    meta = match.get("metadata", {})

                dist = 1.0 - score

                if mid not in id_to_idx:
                    new_idx = len(self.metadata)
                    if hasattr(meta, 'get'):
                        content = meta.get("content", "")
                        doc_name = meta.get("doc_name", "")
                        length = meta.get("length", 0)
                    else:
                        content = getattr(meta, 'content', "")
                        doc_name = getattr(meta, 'doc_name', "")
                        length = getattr(meta, 'length', 0)

                    self.metadata.append({
                        "id": mid,
                        "content": content,
                        "doc_name": doc_name,
                        "length": length,
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
            skipped = 0
            for i, (emb, meta) in enumerate(zip(embeddings, metadata)):
                # Skip zero vectors
                if not any(v != 0 for v in emb.tolist()):
                    print(f"[Pinecone] Skipping zero vector: {meta.get('id', '')}")
                    skipped += 1
                    continue

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

            if skipped > 0:
                print(f"[Pinecone] Skipped {skipped} zero vectors")

            batch_size = 50
            total_batches = (len(vectors) - 1) // batch_size + 1 if vectors else 0
            total_upserted = 0

            for i in range(0, len(vectors), batch_size):
                batch = vectors[i:i + batch_size]
                batch_num = i // batch_size + 1

                for attempt in range(3):
                    try:
                        self._index.upsert(vectors=batch)
                        total_upserted += len(batch)
                        print(f"[Pinecone] Batch {batch_num}/{total_batches} done ({total_upserted}/{len(vectors)})")
                        time.sleep(1)
                        break
                    except Exception as e:
                        print(f"[Pinecone] Batch {batch_num} attempt {attempt+1} failed: {e}")
                        time.sleep(5)
                        if attempt == 2:
                            print(f"[Pinecone] Batch {batch_num} FAILED after 3 attempts!")

            print("[Pinecone] Waiting 15 seconds for Pinecone to stabilize...")
            time.sleep(15)

            stats = self._index.describe_index_stats()
            actual = stats.get("total_vector_count", 0)
            logger.info(f"[Pinecone] Upserted {total_upserted} vectors")
            print(f"[Pinecone] Upserted {total_upserted} vectors successfully!")
            print(f"[Pinecone] Pinecone confirmed: {actual} vectors in cloud!")
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