"""
PDF document loader for RAG pipeline.
"""

import os
from typing import List, Dict, Any
from pathlib import Path
from config.settings import PDF_DIR
from utils.logger import logger

try:
    from PyPDF2 import PdfReader
    PYPDF_AVAILABLE = True
except ImportError:
    PYPDF_AVAILABLE = False
    logger.warning("PyPDF2 not available.")

try:
    import pdfplumber
    PDFPLUMBER_AVAILABLE = True
except ImportError:
    PDFPLUMBER_AVAILABLE = False


class PDFLoader:
    def __init__(self, pdf_directory: str = str(PDF_DIR)):
        self.pdf_directory = Path(pdf_directory)
        self.pdf_directory.mkdir(exist_ok=True)

    def load_single_pdf(self, pdf_path: str) -> Dict[str, Any]:
        pdf_file = Path(pdf_path)
        if not pdf_file.exists():
            logger.warning(f"PDF file not found: {pdf_path}")
            return {"filename": "", "content": "", "metadata": {}}

        num_pages = 0
        full_text = ""

        # Try pdfplumber first (better text extraction)
        if PDFPLUMBER_AVAILABLE:
            try:
                import pdfplumber
                with pdfplumber.open(pdf_path) as pdf:
                    num_pages = len(pdf.pages)
                    text_content = []
                    for page in pdf.pages:
                        text = page.extract_text()
                        if text:
                            text_content.append(text)
                    full_text = "\n".join(text_content)
            except Exception as e:
                logger.warning(f"pdfplumber failed for {pdf_file.name}: {e}")
                full_text = ""

        # Fallback to PyPDF2
        if not full_text and PYPDF_AVAILABLE:
            try:
                reader = PdfReader(pdf_path)
                num_pages = len(reader.pages)
                text_content = []
                for page in reader.pages:
                    text = page.extract_text()
                    if text:
                        text_content.append(text)
                full_text = "\n".join(text_content)
            except Exception as e:
                logger.warning(f"PyPDF2 failed for {pdf_file.name}: {e}")
                full_text = ""

        logger.info(f"Loaded PDF: {pdf_file.name} ({num_pages} pages)")

        if not full_text:
            logger.error(f"Could not load content from {pdf_file.name}")
            return {"filename": "", "content": "", "metadata": {}}

        return {
            "filename": pdf_file.name,
            "content": full_text,
            "metadata": {
                "path": str(pdf_path),
                "num_pages": num_pages,
                "file_size": pdf_file.stat().st_size,
            }
        }

    def load_all_pdfs(self) -> List[Dict[str, Any]]:
        documents = []
        if not self.pdf_directory.exists():
            logger.warning(f"PDF directory not found: {self.pdf_directory}")
            return documents
        pdf_files = list(self.pdf_directory.rglob("*.pdf"))
        logger.info(f"Found {len(pdf_files)} PDF files in {self.pdf_directory}")
        for pdf_file in pdf_files:
            doc = self.load_single_pdf(str(pdf_file))
            if doc["content"]:
                documents.append(doc)
        logger.info(f"Successfully loaded {len(documents)} documents")
        return documents

    def get_pdf_files(self) -> List[str]:
        if not self.pdf_directory.exists():
            return []
        return [str(f) for f in self.pdf_directory.glob("*.pdf")]


_loader: PDFLoader = None


def get_pdf_loader(pdf_directory: str = str(PDF_DIR)) -> PDFLoader:
    global _loader
    if _loader is None:
        _loader = PDFLoader(pdf_directory)
    return _loader