"""
Index a single PDF and ADD it to the existing FAISS vector store
without clearing or re-indexing all other PDFs.
"""

import sys
import os
import numpy as np
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from rag.pdf_loader.loader import get_pdf_loader
from rag.text_chunker.chunker import get_chunker
from rag.embeddings.generator import get_embedding_generator
from rag.vector_store.faiss_store import get_vector_store
from utils.logger import logger


def index_single_pdf(pdf_path: str):
    # Always resolve to absolute path
    pdf_path = Path(os.path.abspath(pdf_path))

    if not pdf_path.exists():
        logger.error(f"File not found: {pdf_path}")
        print(f"[index_single] ERROR: File not found: {pdf_path}")
        return False

    logger.info(f"Indexing single PDF: {pdf_path.name}")
    print(f"[index_single] Starting: {pdf_path.name}")

    try:
        pdf_loader = get_pdf_loader()
        chunker = get_chunker()
        embeddings_gen = get_embedding_generator()
        vector_store = get_vector_store()

        # Load existing index (do NOT clear)
        doc = pdf_loader.load_single_pdf(str(pdf_path))
        if not doc["content"]:
            logger.error(f"Could not load content from {pdf_path.name}")
            print(f"[index_single] ERROR: Could not extract text from {pdf_path.name}")
            return False

        chunks = chunker.chunk_text(doc["content"], doc["filename"])
        logger.info(f"  Created {len(chunks)} chunks")
        print(f"[index_single] Created {len(chunks)} chunks")

        if not chunks:
            logger.error("No chunks created from PDF")
            print("[index_single] ERROR: No chunks created")
            return False

        texts = [c["content"] for c in chunks]
        embeddings = embeddings_gen.encode(texts)

        metadata = [
            {
                'id': c['id'],
                'doc_name': c['doc_name'],
                'content': c['content'],
                'length': c['length']
            }
            for c in chunks
        ]

        # ADD to existing index (not replace)
        vector_store.add_embeddings(np.array(embeddings).astype("float32"), metadata)
        vector_store.save()

        total = vector_store.index.ntotal if vector_store.index else len(chunks)
        logger.info(f"Done! Added {len(chunks)} vectors. Total in store: {total}")
        print(f"[index_single] SUCCESS: Added {len(chunks)} vectors. Total in store: {total}")
        return True

    except Exception as e:
        logger.error(f"Failed to index {pdf_path.name}: {e}")
        print(f"[index_single] EXCEPTION: {e}")
        import traceback
        traceback.print_exc()
        return False


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python index_single.py <path_to_pdf>")
        sys.exit(1)
    success = index_single_pdf(sys.argv[1])
    sys.exit(0 if success else 1)