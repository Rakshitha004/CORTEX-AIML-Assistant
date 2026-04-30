"""
Text chunking for RAG pipeline.
Table-aware chunking with syllabus/scheme detection.
"""

import re
from typing import List, Dict, Any
from config.settings import CHUNK_SIZE, CHUNK_OVERLAP
from utils.logger import logger


# ── Syllabus/Scheme detection keywords ───────────────────────────────────────
SYLLABUS_KEYWORDS = [
    "scheme", "syllabus", "curriculum", "subject code", "course code",
    "credits", "module", "unit", "l t p", "teaching hours",
    "course outcome", "course objective", "pcc", "ipcc", "bsc", "pec",
    "aec", "sec", "hsmc", "oec", "22ai", "21ai", "20ai", "18ai",
    "semester", "elective", "lab course", "theory"
]

def is_syllabus_document(text: str, doc_name: str) -> bool:
    """Detect if this PDF is a syllabus/scheme document"""
    doc_lower = doc_name.lower()
    text_lower = text.lower()[:2000]  # check first 2000 chars

    if any(kw in doc_lower for kw in ["scheme", "syllabus", "curriculum", "2020", "2021", "2022"]):
        return True
    if sum(1 for kw in SYLLABUS_KEYWORDS if kw in text_lower) >= 3:
        return True
    return False


def extract_syllabus_chunks(text: str, doc_name: str) -> List[Dict[str, Any]]:
    """
    Smart syllabus chunking:
    - Detects subject boundaries
    - Keeps subject name + code + credits + modules together
    - Never splits a subject across chunks
    """
    chunks = []
    safe_doc = re.sub(r'[^a-zA-Z0-9]', '_', doc_name)
    chunk_id = 0

    # ── Split by subject/course boundaries ───────────────
    # Patterns that indicate start of a new subject
    subject_patterns = [
        r'(?=(?:PCC|IPCC|BSC|PCCL|PEC|AEC|SEC|HSMC|OEC|ESC|SCR)\s+\d{2}[A-Z]{2,3}\d{2,3})',  # subject type + code
        r'(?=(?:Course Code|Subject Code)\s*[:\|])',  # Course Code: XXX
        r'(?=Module\s+[1-6]\s*[:\|])',  # Module 1:
        r'(?=UNIT\s+[IVX]+\s*[:\|])',   # UNIT I:
    ]

    combined_pattern = '|'.join(subject_patterns)

    # Try to split by subject boundaries
    parts = re.split(combined_pattern, text)

    if len(parts) <= 1:
        # No subject boundaries found — use semester boundaries
        parts = re.split(r'(?=(?:III|IV|V|VI|VII|VIII)\s+Semester)', text)

    if len(parts) <= 1:
        # Fall back to page-like splits on double newlines
        parts = [p for p in re.split(r'\n{3,}', text) if p.strip()]

    # ── Process each part ────────────────────────────────
    for part in parts:
        part = part.strip()
        if not part or len(part) < 50:
            continue

        # Extract subject header info to prepend to every chunk
        subject_header = extract_subject_header(part)

        if len(part) <= CHUNK_SIZE:
            # Fits in one chunk
            chunks.append({
                "id": f"{safe_doc}_{chunk_id}",
                "doc_name": doc_name,
                "content": part,
                "length": len(part),
            })
            chunk_id += 1
        else:
            # Too large — split by modules/units keeping header
            sub_chunks = split_by_modules(part, subject_header, safe_doc, doc_name, chunk_id)
            chunks.extend(sub_chunks)
            chunk_id += len(sub_chunks)

    logger.info(f"[Syllabus Chunker] '{doc_name}' → {len(chunks)} subject chunks")
    return chunks


def extract_subject_header(text: str) -> str:
    """Extract subject name, code, credits from text block"""
    lines = text.split('\n')[:8]  # check first 8 lines
    header_lines = []

    for line in lines:
        line = line.strip()
        if not line:
            continue
        # Keep lines with subject code, name, credits info
        if any(kw in line.lower() for kw in [
            "subject", "course", "code", "credit", "l t p", "hours",
            "semester", "scheme", "pcc", "ipcc", "bsc", "22ai", "21ai", "20ai"
        ]):
            header_lines.append(line)
        elif re.search(r'\d{2}[A-Z]{2,4}\d{2,3}', line):  # subject code pattern
            header_lines.append(line)

    return " | ".join(header_lines[:3]) if header_lines else ""


def split_by_modules(text: str, header: str, safe_doc: str, doc_name: str, start_id: int) -> List[Dict[str, Any]]:
    """Split large subject text by Module/Unit boundaries, prepending header"""
    chunks = []
    chunk_id = start_id

    # Split by Module or Unit
    module_pattern = r'(?=(?:Module|MODULE|Unit|UNIT)\s+[1-6IVX]+)'
    parts = re.split(module_pattern, text)

    if len(parts) <= 1:
        # No modules — just use regular chunking with header
        sentences = text.split('. ')
        current = header + "\n" if header else ""

        for sentence in sentences:
            test = current + sentence + ". "
            if len(test) > CHUNK_SIZE and current.strip():
                chunks.append({
                    "id": f"{safe_doc}_{chunk_id}",
                    "doc_name": doc_name,
                    "content": current.strip(),
                    "length": len(current),
                })
                chunk_id += 1
                overlap = current[-CHUNK_OVERLAP:] if CHUNK_OVERLAP > 0 else ""
                current = (header + "\n" if header else "") + overlap + sentence + ". "
            else:
                current = test

        if current.strip():
            chunks.append({
                "id": f"{safe_doc}_{chunk_id}",
                "doc_name": doc_name,
                "content": current.strip(),
                "length": len(current),
            })
        return chunks

    # Process each module — prepend subject header to each
    for part in parts:
        part = part.strip()
        if not part or len(part) < 30:
            continue

        # Always prepend subject header so context is preserved
        content = f"{header}\n{part}" if header and header not in part else part

        if len(content) <= CHUNK_SIZE:
            chunks.append({
                "id": f"{safe_doc}_{chunk_id}",
                "doc_name": doc_name,
                "content": content,
                "length": len(content),
            })
            chunk_id += 1
        else:
            # Module still too large — split by sentences
            sentences = content.split('. ')
            current = ""
            for sentence in sentences:
                test = current + sentence + ". "
                if len(test) > CHUNK_SIZE and current.strip():
                    chunks.append({
                        "id": f"{safe_doc}_{chunk_id}",
                        "doc_name": doc_name,
                        "content": current.strip(),
                        "length": len(current),
                    })
                    chunk_id += 1
                    overlap = current[-CHUNK_OVERLAP:] if CHUNK_OVERLAP > 0 else ""
                    current = (header + "\n" if header else "") + overlap + sentence + ". "
                else:
                    current = test
            if current.strip():
                chunks.append({
                    "id": f"{safe_doc}_{chunk_id}",
                    "doc_name": doc_name,
                    "content": current.strip(),
                    "length": len(current),
                })
                chunk_id += 1

    return chunks


class TextChunker:
    """
    Split documents into overlapping chunks for embeddings.
    Uses smart syllabus-aware chunking for scheme/syllabus PDFs.
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

        # ── Detect syllabus/scheme documents ─────────────
        if is_syllabus_document(text, doc_name):
            print(f"[Chunker] 📚 Syllabus detected: {doc_name} — using smart chunking")
            return extract_syllabus_chunks(text, doc_name)

        # ── Regular chunking for non-syllabus docs ────────
        print(f"[Chunker] 📄 Regular chunking: {doc_name}")
        chunks = []
        sentences = text.split('. ')
        current_chunk = ""
        chunk_id = 0
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
    _chunker = TextChunker(chunk_size, chunk_overlap)
    return _chunker