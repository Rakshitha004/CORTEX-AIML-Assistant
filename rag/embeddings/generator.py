import os
import time
import numpy as np
import requests
from typing import List, Union
from config.settings import EMBEDDING_MODEL, EMBEDDING_DIM
from utils.logger import logger

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")
TOGETHER_EMBEDDING_MODEL = "intfloat/multilingual-e5-large-instruct"
TOGETHER_EMBEDDING_DIM = 1024


class EmbeddingGenerator:

    def __init__(self, model_name: str = TOGETHER_EMBEDDING_MODEL):
        self.model_name = model_name
        self.embedding_dim = TOGETHER_EMBEDDING_DIM
        logger.info(f"EmbeddingGenerator initialized with Together AI model: {self.model_name}")

    def encode_batch_with_retry(self, batch: list, max_retries: int = 5) -> list:
        """Encode a single batch with retry logic"""
        # ✅ Fixed: 500 chars ≈ 125-250 tokens, always under 512 token limit
        truncated_batch = [text[:500] for text in batch]
        
        for attempt in range(max_retries):
            try:
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
                    logger.error(f"Together AI embedding error (attempt {attempt+1}): {result}")
                    if attempt < max_retries - 1:
                        wait_time = 2 ** attempt
                        logger.info(f"Retrying in {wait_time} seconds...")
                        time.sleep(wait_time)
                        continue
                    return [np.zeros(TOGETHER_EMBEDDING_DIM) for _ in batch]
                
                embeddings = []
                for item in result["data"]:
                    embeddings.append(np.array(item["embedding"]))
                return embeddings
                
            except Exception as e:
                logger.error(f"Embedding error (attempt {attempt+1}): {e}")
                if attempt < max_retries - 1:
                    wait_time = 2 ** attempt
                    logger.info(f"Retrying in {wait_time} seconds...")
                    time.sleep(wait_time)
                    continue
                return [np.zeros(TOGETHER_EMBEDDING_DIM) for _ in batch]
        
        return [np.zeros(TOGETHER_EMBEDDING_DIM) for _ in batch]

    def encode(self, texts):
        try:
            if isinstance(texts, str):
                texts = [texts]
            
            all_embeddings = []
            batch_size = 5

            for i in range(0, len(texts), batch_size):
                batch = texts[i:i + batch_size]
                print(f"[Embeddings] Batch {i//batch_size + 1}/{(len(texts)-1)//batch_size + 1}")
                
                batch_embeddings = self.encode_batch_with_retry(batch)
                all_embeddings.extend(batch_embeddings)
                
                if i + batch_size < len(texts):
                    time.sleep(0.5)

            embeddings = np.array(all_embeddings)
            return embeddings
            
        except Exception as e:
            logger.error(f"Error generating embeddings: {e}")
            return np.zeros((len(texts) if isinstance(texts, list) else 1, TOGETHER_EMBEDDING_DIM))

    def similarity(self, embedding1, embedding2):
        if len(embedding1) == 0 or len(embedding2) == 0:
            return 0.0
        norm1 = np.linalg.norm(embedding1)
        norm2 = np.linalg.norm(embedding2)
        if norm1 == 0 or norm2 == 0:
            return 0.0
        return float(np.dot(embedding1/norm1, embedding2/norm2))


_generator = None


def get_embedding_generator(model_name: str = TOGETHER_EMBEDDING_MODEL):
    global _generator
    if _generator is None:
        _generator = EmbeddingGenerator(model_name)
    return _generator