"""
PDF document loader for RAG pipeline.
"""
import os
import re
import base64
import requests
import time
import zipfile
import tempfile
from typing import List, Dict, Any
from pathlib import Path
from config.settings import PDF_DIR
from utils.logger import logger

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")
SARVAM_API_KEY = os.getenv("SARVAM_API_KEY", "")

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

try:
    import pypdfium2 as pdfium
    PDFIUM_AVAILABLE = True
except ImportError:
    PDFIUM_AVAILABLE = False


def clean_text(text: str) -> str:
    """Clean extracted PDF text"""
    clean_lines = []
    for line in text.split('\n'):
        line = line.strip()
        if not line:
            continue
        if len(line) < 3:
            continue
        ascii_chars = sum(1 for c in line if c.isascii())
        if len(line) > 0 and (ascii_chars / len(line)) < 0.6:
            continue
        words = line.split()
        if len(words) > 5:
            single_char_words = sum(1 for w in words if len(w) == 1)
            if single_char_words / len(words) > 0.5:
                continue
        if re.match(r'^[.\-_=\s]+$', line):
            continue
        alpha_chars = sum(1 for c in line if c.isalpha())
        if len(line) > 10 and alpha_chars / len(line) < 0.2:
            continue
        clean_lines.append(line)
    return '\n'.join(clean_lines)


def extract_tables_with_pdfplumber(pdf_path: str) -> str:
    """Extract tables properly using pdfplumber"""
    try:
        import pdfplumber
        full_text = []
        with pdfplumber.open(pdf_path) as pdf:
            for page_num, page in enumerate(pdf.pages):
                try:
                    text = page.extract_text()
                    if text:
                        full_text.append(text)
                    tables = page.extract_tables()
                    for table in tables:
                        if table:
                            for row in table:
                                if row:
                                    row_text = " | ".join(
                                        str(cell).strip() if cell else ""
                                        for cell in row
                                    )
                                    if row_text.strip():
                                        full_text.append(row_text)
                except Exception as page_err:
                    logger.warning(f"Page {page_num} extraction failed: {page_err}")
                    continue
        return clean_text("\n".join(full_text))
    except Exception as e:
        logger.warning(f"pdfplumber table extraction failed: {e}")
        return ""


def extract_with_sarvam_vision(pdf_path: str) -> str:
    """Use Sarvam Vision API for scanned PDFs"""
    if not SARVAM_API_KEY:
        logger.warning("No Sarvam API key for vision extraction")
        return ""

    try:
        from sarvamai import SarvamAI
        client = SarvamAI(api_subscription_key=SARVAM_API_KEY)

        print(f"[Sarvam Vision] Processing: {Path(pdf_path).name}")

        # Create job
        job = client.document_intelligence.create_job(
            language="en-IN",
            output_format="md"
        )
        print(f"[Sarvam Vision] Job created: {job.job_id}")

        # Upload PDF directly
        job.upload_file(pdf_path)
        print(f"[Sarvam Vision] File uploaded")

        # Start processing
        job.start()
        print(f"[Sarvam Vision] Processing started...")

        # Wait for completion
        status = job.wait_until_complete()
        print(f"[Sarvam Vision] Status: {status.job_state}")

        # Download output to temp file
        with tempfile.TemporaryDirectory() as tmpdir:
            zip_path = os.path.join(tmpdir, "output.zip")
            job.download_output(zip_path)

            # Extract markdown from zip
            extracted_text = []
            with zipfile.ZipFile(zip_path, 'r') as z:
                for filename in z.namelist():
                    if filename.endswith('.md'):
                        with z.open(filename) as f:
                            content = f.read().decode('utf-8')
                            extracted_text.append(content)

            if extracted_text:
                full_text = "\n\n".join(extracted_text)
                print(f"[Sarvam Vision] ✅ Extracted {len(full_text)} chars")
                return clean_text(full_text)

        return ""

    except Exception as e:
        logger.warning(f"Sarvam Vision failed: {e}")
        return ""


def is_text_quality_good(text: str, min_chars: int = 100) -> bool:
    """Check if extracted text is good quality"""
    if not text or len(text) < min_chars:
        return False
    words = text.split()
    if len(words) < 20:
        return False
    alpha_chars = sum(1 for c in text if c.isalpha())
    if len(text) > 0 and alpha_chars / len(text) < 0.3:
        return False
    return True


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

        # ── Step 1: pdfplumber with table extraction ──────
        if PDFPLUMBER_AVAILABLE:
            try:
                full_text = extract_tables_with_pdfplumber(pdf_path)
                with pdfplumber.open(pdf_path) as pdf:
                    num_pages = len(pdf.pages)
                if is_text_quality_good(full_text):
                    print(f"[Loader] ✅ pdfplumber: {pdf_file.name}")
                else:
                    full_text = ""
            except Exception as e:
                logger.warning(f"pdfplumber failed: {e}")
                full_text = ""

        # ── Step 2: PyPDF2 fallback ────────────────────────
        if not is_text_quality_good(full_text) and PYPDF_AVAILABLE:
            try:
                reader = PdfReader(pdf_path)
                num_pages = len(reader.pages)
                text_content = []
                for page in reader.pages:
                    try:
                        text = page.extract_text()
                        if text:
                            text_content.append(text)
                    except Exception:
                        continue
                full_text = clean_text("\n".join(text_content))
                if is_text_quality_good(full_text):
                    print(f"[Loader] ✅ PyPDF2: {pdf_file.name}")
                else:
                    full_text = ""
            except Exception as e:
                logger.warning(f"PyPDF2 failed: {e}")
                full_text = ""

        # ── Step 3: Sarvam Vision fallback ────────────────
        if not is_text_quality_good(full_text):
            print(f"[Loader] 👁️ Sarvam Vision: {pdf_file.name}")
            full_text = extract_with_sarvam_vision(pdf_path)
            if is_text_quality_good(full_text):
                print(f"[Loader] ✅ Sarvam Vision: {pdf_file.name}")
            else:
                print(f"[Loader] ❌ All methods failed: {pdf_file.name}")

        if num_pages == 0:
            try:
                with pdfplumber.open(pdf_path) as pdf:
                    num_pages = len(pdf.pages)
            except Exception:
                pass

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
            logger.warning(
                f"PDF directory not found: {self.pdf_directory}"
            )
            return documents

        pdf_files = list(self.pdf_directory.rglob("*.pdf"))
        logger.info(
            f"Found {len(pdf_files)} PDF files in {self.pdf_directory}"
        )

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