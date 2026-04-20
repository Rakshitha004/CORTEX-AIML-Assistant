"""
Initialization script for the LLM Student Assistant.
Loads student data and initializes RAG system.
"""

import sys
import numpy as np
from pathlib import Path

# Add project to path
sys.path.insert(0, str(Path(__file__).parent))

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

    # ── Also include uploaded_docs folder ──────────────────
    PDF_ROOT = Path(r"C:\Dev\Multi-Agent-Dept-Digital-Asst\Multi-Agent-Dept-Digital-Asst\data\pdf_documents")
    UPLOAD_DIR = Path(r"C:\Dev\AIML-Dept-Digital-Assistant\aiml-department-digital-assistant\uploaded_docs")

    all_pdfs = list(PDF_ROOT.rglob("*.pdf"))

    # Add uploaded PDFs if folder exists
    if UPLOAD_DIR.exists():
        uploaded_pdfs = list(UPLOAD_DIR.rglob("*.pdf"))
        all_pdfs.extend(uploaded_pdfs)
        logger.info(f"Found {len(uploaded_pdfs)} uploaded PDFs in uploaded_docs")

    logger.info(f"Found {len(all_pdfs)} PDFs total")

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

    logger.info("Creating fresh FAISS index...")

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

    # Safe check
    if vector_store.index is not None:
        logger.info(f"Done! Vector store now has {vector_store.index.ntotal} vectors")
    else:
        logger.info(f"Done! Vector store saved with {len(all_chunks)} chunks")

    logger.info("=" * 60)
    logger.info("Re-indexing Complete!")
    logger.info("=" * 60)


if __name__ == "__main__":
    main()