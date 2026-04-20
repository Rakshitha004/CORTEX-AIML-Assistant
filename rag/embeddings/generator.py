"""
Embeddings generation for RAG pipeline using Together AI API.
"""
import numpy as np
import requests
from typing import List, Union
from config.settings import EMBEDDING_MODEL, EMBEDDING_DIM
from utils.logger import logger

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")
TOGETHER_EMBEDDING_MODEL = "intfloat/multilingual-e5-large-instruct"
TOGETHER_EMBEDDING_DIM = 1024


class EmbeddingGenerator:
    """Generate embeddings for text using Together AI API."""

    def __init__(self, model_name: str = TOGETHER_EMBEDDING_MODEL):
        self.model_name = model_name
        self.embedding_dim = TOGETHER_EMBEDDING_DIM
        logger.info(f"EmbeddingGenerator initialized with Together AI model: {self.model_name}")

    def encode(self, texts: Union[str, List[str]]) -> np.ndarray:
        """
        Encode text(s) to embeddings using Together AI API.

        Args:
            texts: Single text or list of texts

        Returns:
            Embedding vectors as numpy array
        """
        try:
            if isinstance(texts, str):
                texts = [texts]

            all_embeddings = []

            # Process in batches of 10 to avoid API limits
            batch_size = 10
            for i in range(0, len(texts), batch_size):
                batch = texts[i:i + batch_size]

                # Truncate each text to safe limit (512 tokens ~ 1200 chars)
                truncated_batch = [text[:1200] for text in batch]

                response = requests.post(
                    "https://api.together.xyz/v1/embeddings",
                    headers={
                        "Authorization": f"Bearer {TOGETHER_API_KEY}",
                        "Content-Type": "application/json"
                    },
                    json={
                        "model": TOGETHER_EMBEDDING_MODEL,
                        "input": truncated_batch
                    },
                    timeout=60
                )

                result = response.json()

                if "data" not in result:
                    logger.error(f"Together AI embedding error: {result}")
                    # Return zero embeddings as fallback
                    for _ in batch:
                        all_embeddings.append(np.zeros(TOGETHER_EMBEDDING_DIM))
                    continue

                for item in result["data"]:
                    all_embeddings.append(np.array(item["embedding"]))

                logger.debug(f"Generated embeddings for batch {i//batch_size + 1}")

            embeddings = np.array(all_embeddings)
            logger.debug(f"Generated embeddings for {len(texts)} text(s), shape: {embeddings.shape}")
            return embeddings

        except Exception as e:
            logger.error(f"Error generating embeddings: {e}")
            # Return zero embeddings as fallback
            return np.zeros((len(texts) if isinstance(texts, list) else 1, TOGETHER_EMBEDDING_DIM))

    def similarity(self, embedding1: np.ndarray, embedding2: np.ndarray) -> float:
        """
        Calculate cosine similarity between two embeddings.
        """
        if len(embedding1) == 0 or len(embedding2) == 0:
            return 0.0

        norm1 = np.linalg.norm(embedding1)
        norm2 = np.linalg.norm(embedding2)

        if norm1 == 0 or norm2 == 0:
            return 0.0

        embedding1_normalized = embedding1 / norm1
        embedding2_normalized = embedding2 / norm2

        similarity = np.dot(embedding1_normalized, embedding2_normalized)
        return float(similarity)


# Global embedding generator instance
_generator: EmbeddingGenerator = None


def get_embedding_generator(model_name: str = TOGETHER_EMBEDDING_MODEL) -> EmbeddingGenerator:
    """
    Get or create global embedding generator instance.
    """
    global _generator

    if _generator is None:
        _generator = EmbeddingGenerator(model_name)

    return _generator
