"""
Initialization script for the LLM Student Assistant.
Loads student data and initializes RAG system.
"""
import certifi
import os
os.environ["SSL_CERT_FILE"] = certifi.where()
os.environ["REQUESTS_CA_BUNDLE"] = certifi.where()

import sys
from dotenv import load_dotenv
load_dotenv()  # MUST be first!

import numpy as np
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

# Force fresh vector store — reset global cache
import importlib
import rag.vector_store.faiss_store as fs
fs._vector_store = None  # Reset cached instance so it reconnects with loaded API key

from config.settings import PDF_DIR
from rag.pdf_loader.loader import get_pdf_loader
from rag.text_chunker.chunker import get_chunker
from rag.embeddings.generator import get_embedding_generator
from rag.vector_store.faiss_store import get_vector_store
from utils.logger import logger


def main():
    logger.info("=" * 60)
    logger.info("CORTEX - Re-indexing All PDFs")
    logger.info("=" * 60)

    PDF_ROOT = Path(r"C:\Dev\AIML-Dept-Digital-Assistant\aiml-department-digital-assistant\uploaded_docs")

    all_pdfs = list(PDF_ROOT.rglob("*.pdf"))
    logger.info(f"Found {len(all_pdfs)} PDFs in uploaded_docs")

    if len(all_pdfs) == 0:
        logger.error("No PDFs found! Check your PDF directories.")
        return

    pdf_loader = get_pdf_loader()
    chunker = get_chunker()
    embeddings_gen = get_embedding_generator()
    vector_store = get_vector_store()
    vector_store.clear()

    all_chunks = []
    all_embeddings = []

    for pdf_path in all_pdfs:
        try:
            logger.info(f"Processing: {pdf_path.name}")
            doc = pdf_loader.load_single_pdf(str(pdf_path))
            if not doc["content"]:
                logger.warning(f"  Skipping - could not load")
                continue
            chunks = chunker.chunk_text(doc["content"], doc["filename"])
            logger.info(f"  {len(chunks)} chunks")
            texts = [c["content"] for c in chunks]
            embeddings = embeddings_gen.encode(texts)
            all_chunks.extend(chunks)
            all_embeddings.extend(embeddings)
        except Exception as e:
            logger.error(f"  Failed to process {pdf_path.name}: {e}")
            continue

    logger.info(f"Total chunks: {len(all_chunks)}")

    if len(all_chunks) == 0:
        logger.error("No chunks created! Check your PDFs.")
        return

    if len(all_embeddings) == 0:
        logger.error("No embeddings generated!")
        return

    logger.info("Creating fresh Pinecone index...")

    metadata = [
        {
            'id': c['id'],
            'doc_name': c['doc_name'],
            'content': c['content'],
            'length': c['length']
        }
        for c in all_chunks
    ]

    vector_store.add_embeddings(np.array(all_embeddings).astype("float32"), metadata)
    vector_store.save()

    # Verify with Pinecone directly
    import os
    from pinecone import Pinecone
    pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
    idx = pc.Index("cortex-rag")
    stats = idx.describe_index_stats()
    actual_count = stats.get("total_vector_count", 0)
    logger.info(f"✅ Pinecone confirmed: {actual_count} vectors in cloud!")
    print(f"✅ Pinecone confirmed: {actual_count} vectors in cloud!")

    logger.info("=" * 60)
    logger.info("Re-indexing Complete!")
    logger.info("=" * 60)


if __name__ == "__main__":
    main()