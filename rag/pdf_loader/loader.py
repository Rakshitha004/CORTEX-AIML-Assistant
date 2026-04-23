"""
PDF document loader for RAG pipeline.
"""
import os
import re
import base64
import requests
from typing import List, Dict, Any
from pathlib import Path
from config.settings import PDF_DIR
from utils.logger import logger

TOGETHER_API_KEY = os.getenv("TOGETHER_API_KEY", "")
VISION_MODEL = "meta-llama/Llama-3.2-11B-Vision-Instruct-Turbo"

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
            for page in pdf.pages:
                # Extract normal text
                text = page.extract_text()
                if text:
                    full_text.append(text)

                # ✅ Extract tables properly
                tables = page.extract_tables()
                for table in tables:
                    if table:
                        for row in table:
                            if row:
                                # Join cells with | separator
                                row_text = " | ".join(
                                    str(cell).strip() if cell else ""
                                    for cell in row
                                )
                                if row_text.strip():
                                    full_text.append(row_text)

        return clean_text("\n".join(full_text))
    except Exception as e:
        logger.warning(f"pdfplumber table extraction failed: {e}")
        return ""


def extract_with_vision_ai(pdf_path: str) -> str:
    """Use Together AI Vision model to read PDF pages as images"""
    if not PDFIUM_AVAILABLE:
        logger.warning("pypdfium2 not available for vision extraction")
        return ""

    if not TOGETHER_API_KEY:
        logger.warning("No Together AI key for vision extraction")
        return ""

    try:
        import pypdfium2 as pdfium
        from PIL import Image
        import io

        pdf = pdfium.PdfDocument(pdf_path)
        all_text = []

        # Process max 10 pages to avoid too many API calls
        max_pages = min(len(pdf), 10)

        for page_num in range(max_pages):
            try:
                page = pdf[page_num]

                # Render page to image
                bitmap = page.render(scale=2)  # 2x scale for better quality
                pil_image = bitmap.to_pil()

                # Convert to base64
                buffer = io.BytesIO()
                pil_image.save(buffer, format="PNG")
                image_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")

                # Send to Together AI Vision
                response = requests.post(
                    "https://api.together.xyz/v1/chat/completions",
                    headers={
                        "Authorization": f"Bearer {TOGETHER_API_KEY}",
                        "Content-Type": "application/json"
                    },
                    json={
                        "model": VISION_MODEL,
                        "messages": [
                            {
                                "role": "user",
                                "content": [
                                    {
                                        "type": "image_url",
                                        "image_url": {
                                            "url": f"data:image/png;base64,{image_base64}"
                                        }
                                    },
                                    {
                                        "type": "text",
                                        "text": """Extract ALL text from this page including:
1. All regular text paragraphs
2. All table contents with proper row/column structure
3. All headings and subheadings
4. Any names, numbers, dates

Format tables as: Column1 | Column2 | Column3
Extract everything exactly as shown, do not summarize."""
                                    }
                                ]
                            }
                        ],
                        "max_tokens": 2000,
                        "temperature": 0
                    },
                    timeout=60
                )

                page_text = response.json()["choices"][0]["message"]["content"]
                all_text.append(f"--- Page {page_num + 1} ---\n{page_text}")
                print(f"[Vision AI] Extracted page {page_num + 1} of {max_pages}")

            except Exception as e:
                logger.warning(f"Vision extraction failed for page {page_num}: {e}")
                continue

        pdf.close()
        return "\n\n".join(all_text)

    except Exception as e:
        logger.warning(f"Vision AI extraction failed: {e}")
        return ""


def is_text_quality_good(text: str, min_chars: int = 100) -> bool:
    """Check if extracted text is good quality"""
    if not text or len(text) < min_chars:
        return False
    # Check if text has meaningful words
    words = text.split()
    if len(words) < 20:
        return False
    # Check if too many special characters
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

        # ── Step 1: Try pdfplumber with table extraction ──
        if PDFPLUMBER_AVAILABLE:
            try:
                full_text = extract_tables_with_pdfplumber(pdf_path)
                with pdfplumber.open(pdf_path) as pdf:
                    num_pages = len(pdf.pages)
                if is_text_quality_good(full_text):
                    print(f"[Loader] pdfplumber success: {pdf_file.name}")
            except Exception as e:
                logger.warning(f"pdfplumber failed: {e}")
                full_text = ""

        # ── Step 2: Fallback to PyPDF2 ────────────────────
        if not is_text_quality_good(full_text) and PYPDF_AVAILABLE:
            try:
                reader = PdfReader(pdf_path)
                num_pages = len(reader.pages)
                text_content = []
                for page in reader.pages:
                    text = page.extract_text()
                    if text:
                        text_content.append(text)
                full_text = clean_text("\n".join(text_content))
                if is_text_quality_good(full_text):
                    print(f"[Loader] PyPDF2 success: {pdf_file.name}")
            except Exception as e:
                logger.warning(f"PyPDF2 failed: {e}")
                full_text = ""

        # ── Step 3: Vision AI fallback ────────────────────
        if not is_text_quality_good(full_text):
            print(f"[Loader] Using Vision AI for: {pdf_file.name}")
            full_text = extract_with_vision_ai(pdf_path)
            if is_text_quality_good(full_text):
                print(f"[Loader] Vision AI success: {pdf_file.name}")

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