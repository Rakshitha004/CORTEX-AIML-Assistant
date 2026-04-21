"""
Text chunking for RAG pipeline.
"""

import re
from typing import List, Dict, Any
from config.settings import CHUNK_SIZE, CHUNK_OVERLAP
from utils.logger import logger


class TextChunker:
    """
    Split documents into overlapping chunks for embeddings.
    """

    def __init__(
        self,
        chunk_size: int = CHUNK_SIZE,
        chunk_overlap: int = CHUNK_OVERLAP,
    ):
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap

        if chunk_overlap >= chunk_size:
            logger.warning("Chunk overlap >= chunk size. Setting overlap to 0")
            self.chunk_overlap = 0

    def chunk_text(self, text: str, doc_name: str = "") -> List[Dict[str, Any]]:
        if not text or not text.strip():
            logger.warning(f"Empty text for document: {doc_name}")
            return []

        chunks = []
        sentences = text.split('. ')

        current_chunk = ""
        chunk_id = 0

        # Create a safe ASCII-only prefix from doc_name for unique IDs
        safe_doc = re.sub(r'[^a-zA-Z0-9]', '_', doc_name)

        for sentence in sentences:
            test_chunk = current_chunk + sentence + ". "

            if len(test_chunk) > self.chunk_size and current_chunk:
                chunks.append({
                    "id": f"{safe_doc}_{chunk_id}",
                    "doc_name": doc_name,
                    "content": current_chunk.strip(),
                    "length": len(current_chunk),
                })
                chunk_id += 1

                overlap_text = current_chunk[-self.chunk_overlap:] if self.chunk_overlap > 0 else ""
                current_chunk = overlap_text + sentence + ". "
            else:
                current_chunk = test_chunk

        if current_chunk.strip():
            chunks.append({
                "id": f"{safe_doc}_{chunk_id}",
                "doc_name": doc_name,
                "content": current_chunk.strip(),
                "length": len(current_chunk),
            })

        logger.info(f"Chunked document '{doc_name}' into {len(chunks)} chunks")
        return chunks

    def chunk_documents(self, documents: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        all_chunks = []

        for doc in documents:
            content = doc.get("content", "")
            filename = doc.get("filename", "unknown")

            if not content:
                logger.warning(f"Skipping document with empty content: {filename}")
                continue

            chunks = self.chunk_text(content, filename)
            all_chunks.extend(chunks)

        logger.info(f"Created {len(all_chunks)} chunks from {len(documents)} documents")
        return all_chunks

    def chunk_query(self, query: str) -> List[str]:
        if len(query) <= self.chunk_size:
            return [query]

        chunks = []
        for i in range(0, len(query), self.chunk_size - self.chunk_overlap):
            chunk = query[i:i + self.chunk_size]
            if chunk.strip():
                chunks.append(chunk)

        return chunks


# Global chunker instance
_chunker: TextChunker = None


def get_chunker(
    chunk_size: int = CHUNK_SIZE,
    chunk_overlap: int = CHUNK_OVERLAP,
) -> TextChunker:
    global _chunker
    # Always recreate with current settings so chunk_size changes take effect
    _chunker = TextChunker(chunk_size, chunk_overlap)
    return _chunker