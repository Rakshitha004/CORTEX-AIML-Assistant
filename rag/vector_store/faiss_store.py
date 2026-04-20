"""
FAISS vector store for RAG pipeline.
"""

import pickle
import numpy as np
from pathlib import Path
from typing import List, Dict, Any, Optional
from config.settings import VECTOR_DB_PATH, VECTOR_DB_METADATA_PATH, EMBEDDING_DIM, TOP_K_CHUNKS
from utils.logger import logger

try:
    import faiss
    FAISS_AVAILABLE = True
except ImportError:
    FAISS_AVAILABLE = False
    logger.warning("faiss not available. Install with: pip install faiss-cpu")


class FAISSVectorStore:
    """FAISS-based vector store for storing and retrieving embeddings."""

    def __init__(self, embedding_dim: int = EMBEDDING_DIM):
        """
        Initialize FAISS vector store.

        Args:
            embedding_dim: Dimension of embedding vectors
        """
        self.embedding_dim = embedding_dim
        self.index = None
        self.metadata: List[Dict[str, Any]] = []
        self.index_path = Path(VECTOR_DB_PATH)
        self.metadata_path = Path(VECTOR_DB_METADATA_PATH)

        if not FAISS_AVAILABLE:
            logger.error("FAISS is not available")
            return

        # Load existing index if available
        if self.index_path.exists() and self.metadata_path.exists():
            self.load()
        else:
            self._create_index()

    def _create_index(self):
        """Create a new FAISS index."""
        if not FAISS_AVAILABLE:
            return
        self.index = faiss.IndexFlatL2(self.embedding_dim)
        self.metadata = []
        logger.info(f"Created new FAISS index with dim={self.embedding_dim}")

    def add_embeddings(self, embeddings: np.ndarray, metadata: List[Dict[str, Any]]) -> bool:
        """
        Add embeddings and their metadata to the store.

        Args:
            embeddings: Numpy array of shape (n, embedding_dim)
            metadata: List of metadata dicts for each embedding

        Returns:
            True if successful
        """
        if not FAISS_AVAILABLE or self.index is None:
            logger.error("FAISS index not initialized")
            return False

        try:
            if len(embeddings) == 0:
                logger.warning("No embeddings to add")
                return False

            embeddings = np.array(embeddings).astype("float32")
            self.index.add(embeddings)
            self.metadata.extend(metadata)

            logger.info(f"Added {len(embeddings)} embeddings to vector store")
            return True

        except Exception as e:
            logger.error(f"Error adding embeddings: {e}")
            return False

    def search(self, query_embedding: np.ndarray, top_k: int = TOP_K_CHUNKS) -> List[Dict[str, Any]]:
        """
        Search for similar embeddings.

        Args:
            query_embedding: Query embedding vector
            top_k: Number of top results to return

        Returns:
            List of metadata dicts for top results
        """
        if not FAISS_AVAILABLE or self.index is None:
            logger.error("FAISS index not initialized")
            return []

        try:
            if self.index.ntotal == 0:
                logger.warning("Vector store is empty")
                return []

            query = np.array([query_embedding]).astype("float32")
            distances, indices = self.index.search(query, min(top_k, self.index.ntotal))

            results = []
            for dist, idx in zip(distances[0], indices[0]):
                if idx < len(self.metadata):
                    result = self.metadata[idx].copy()
                    result["distance"] = float(dist)
                    results.append(result)

            logger.debug(f"Found {len(results)} results for query")
            return results

        except Exception as e:
            logger.error(f"Error searching vector store: {e}")
            return []

    def save(self) -> bool:
        """
        Save index and metadata to disk.

        Returns:
            True if successful
        """
        if not FAISS_AVAILABLE or self.index is None:
            return False

        try:
            self.index_path.parent.mkdir(parents=True, exist_ok=True)
            faiss.write_index(self.index, str(self.index_path))

            with open(self.metadata_path, "wb") as f:
                pickle.dump(self.metadata, f)

            logger.info(f"Vector store saved to {self.index_path}")
            return True

        except Exception as e:
            logger.error(f"Error saving vector store: {e}")
            return False

    def load(self) -> bool:
        """
        Load index and metadata from disk.

        Returns:
            True if successful
        """
        if not FAISS_AVAILABLE:
            return False

        try:
            self.index = faiss.read_index(str(self.index_path))

            with open(self.metadata_path, "rb") as f:
                self.metadata = pickle.load(f)

            logger.info(f"Vector store loaded from {self.index_path} ({self.index.ntotal} vectors)")
            return True

        except Exception as e:
            logger.error(f"Error loading vector store: {e}")
            self._create_index()
            return False

    def get_stats(self) -> Dict[str, Any]:
        """
        Get vector store statistics.

        Returns:
            Dict with stats
        """
        return {
            "total_vectors": self.index.ntotal if self.index else 0,
            "embedding_dim": self.embedding_dim,
            "metadata_count": len(self.metadata),
            "index_path": str(self.index_path),
            "faiss_available": FAISS_AVAILABLE,
        }

    def clear(self):
        """Clear the vector store."""
        self._create_index()
        logger.info("Vector store cleared")


# Global vector store instance
_vector_store: Optional[FAISSVectorStore] = None


def get_vector_store(embedding_dim: int = EMBEDDING_DIM) -> FAISSVectorStore:
    """
    Get or create global vector store instance.

    Args:
        embedding_dim: Dimension of embeddings

    Returns:
        FAISSVectorStore instance
    """
    global _vector_store

    if _vector_store is None:
        _vector_store = FAISSVectorStore(embedding_dim)

    return _vector_store