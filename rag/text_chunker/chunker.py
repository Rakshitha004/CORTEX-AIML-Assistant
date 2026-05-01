"""
Text chunking for RAG pipeline.
Table-aware chunking with syllabus/scheme detection.
"""

import re
from typing import List, Dict, Any
from config.settings import CHUNK_SIZE, CHUNK_OVERLAP
from utils.logger import logger


SYLLABUS_KEYWORDS = [
    "scheme", "syllabus", "curriculum", "subject code", "course code",
    "credits", "module", "unit", "l t p", "teaching hours",
    "course outcome", "course objective", "pcc", "ipcc", "bsc", "pec",
    "aec", "sec", "hsmc", "oec", "22ai", "21ai", "20ai", "18ai",
    "semester", "elective", "lab course", "theory"
]

def is_syllabus_document(text: str, doc_name: str) -> bool:
    doc_lower = doc_name.lower()
    text_lower = text.lower()[:2000]
    if any(kw in doc_lower for kw in ["scheme", "syllabus", "curriculum", "2020", "2021", "2022"]):
        return True
    if sum(1 for kw in SYLLABUS_KEYWORDS if kw in text_lower) >= 3:
        return True
    return False


def clean_pdf_text(text: str) -> str:
    """Remove garbled rotated text produced by pdfplumber on scheme PDFs."""
    lines = text.split('\n')
    clean_lines = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            clean_lines.append(line)
            continue
        words = stripped.split()
        if len(words) > 5:
            single_chars = sum(1 for w in words if len(w) == 1)
            if single_chars / len(words) > 0.5:  # >50% single chars = garbled rotated text
                continue
        clean_lines.append(line)
    return '\n'.join(clean_lines)


def extract_syllabus_chunks(text: str, doc_name: str) -> List[Dict[str, Any]]:
    # ── Clean garbled rotated text first ──
    text = clean_pdf_text(text)

    chunks = []
    safe_doc = re.sub(r'[^a-zA-Z0-9]', '_', doc_name)
    chunk_id = 0

    # ── STEP 1: Always split by semester boundary first ──
    semester_parts = re.split(
        r'\n(?=(?:VIII|VII|VI|IV|V|III|II|I)\s+SEMESTER)',
        text,
        flags=re.IGNORECASE
    )

    # If no semester boundaries found, treat whole doc as one part
    if len(semester_parts) <= 1:
        semester_parts = [text]

    for sem_part in semester_parts:
        sem_part = sem_part.strip()
        if not sem_part:
            continue

        # Detect which semester this part belongs to
        sem_heading_match = re.search(
            r'\b(I|II|III|IV|V|VI|VII|VIII)\s+SEMESTER\b',
            sem_part[:300], flags=re.IGNORECASE
        )
        sem_context = ""
        if sem_heading_match:
            roman_map = {
                "I": "1st", "II": "2nd", "III": "3rd", "IV": "4th",
                "V": "5th", "VI": "6th", "VII": "7th", "VIII": "8th"
            }
            sem_num = roman_map.get(sem_heading_match.group(1).upper(), sem_heading_match.group(1))
            sem_context = f"Semester: {sem_num}"

        # ── STEP 2: Split each semester part by subject ──
        subject_patterns = [
            r'(?=(?:PCC|IPCC|BSC|PCCL|PEC|AEC|SEC|HSMC|OEC|ESC|SCR)\s+\d{2}[A-Z]{2,3}\d{2,3})',
            r'(?=(?:Course Code|Subject Code)\s*[:\|])',
            r'(?=Module\s+[1-6]\s*[:\|])',
            r'(?=UNIT\s+[IVX]+\s*[:\|])',
        ]
        combined_pattern = '|'.join(subject_patterns)
        parts = re.split(combined_pattern, sem_part)

        if len(parts) <= 1:
            parts = [p for p in re.split(r'\n{3,}', sem_part) if p.strip()]

        for part in parts:
            part = part.strip()
            if not part or len(part) < 50:
                continue

            subject_header = extract_subject_header(part)

            # ── Inject semester context if not already present ──
            if sem_context and sem_context not in subject_header:
                subject_header = f"{sem_context} | {subject_header}" if subject_header else sem_context

            if len(part) <= CHUNK_SIZE:
                content = f"{subject_header}\n{part}" if subject_header and subject_header not in part else part
                chunks.append({
                    "id": f"{safe_doc}_{chunk_id}",
                    "doc_name": doc_name,
                    "content": content,
                    "length": len(content),
                })
                chunk_id += 1
            else:
                sub_chunks = split_by_modules(part, subject_header, safe_doc, doc_name, chunk_id)
                chunks.extend(sub_chunks)
                chunk_id += len(sub_chunks)

    logger.info(f"[Syllabus Chunker] '{doc_name}' -> {len(chunks)} subject chunks")
    return chunks


def extract_subject_header(text: str) -> str:
    lines = text.split('\n')[:8]
    header_lines = []
    scheme_info = ""

    course_match = re.search(r'\b(\d{2})(AI|MA|HS|NS|PE)(\d)[A-Z]{2,6}\b', text[:500])
    if course_match:
        year_map = {"18": "2018", "20": "2020", "21": "2021", "22": "2022"}
        sem_map = {
            "1": "1st", "2": "2nd", "3": "3rd", "4": "4th",
            "5": "5th", "6": "6th", "7": "7th", "8": "8th"
        }
        year = year_map.get(course_match.group(1), course_match.group(1))
        sem = sem_map.get(course_match.group(3), course_match.group(3))
        scheme_info = f"Scheme: {year} | Semester: {sem}"

    # Also detect semester from heading like "III SEMESTER"
    sem_heading_match = re.search(
        r'\b(I|II|III|IV|V|VI|VII|VIII)\s+SEMESTER\b',
        text[:300], flags=re.IGNORECASE
    )
    if sem_heading_match and not scheme_info:
        roman_map = {
            "I": "1st", "II": "2nd", "III": "3rd", "IV": "4th",
            "V": "5th", "VI": "6th", "VII": "7th", "VIII": "8th"
        }
        sem = roman_map.get(sem_heading_match.group(1).upper(), sem_heading_match.group(1))
        scheme_info = f"Semester: {sem}"

    for line in lines:
        line = line.strip()
        if not line:
            continue
        if any(kw in line.lower() for kw in [
            "subject", "course", "code", "credit", "l t p", "hours",
            "semester", "scheme", "pcc", "ipcc", "bsc", "22ai", "21ai", "20ai"
        ]):
            header_lines.append(line)
        elif re.search(r'\d{2}[A-Z]{2,4}\d{2,3}', line):
            header_lines.append(line)

    base_header = " | ".join(header_lines[:3]) if header_lines else ""

    if scheme_info and base_header:
        return f"{scheme_info} | {base_header}"
    return scheme_info or base_header


def split_by_modules(text: str, header: str, safe_doc: str, doc_name: str, start_id: int) -> List[Dict[str, Any]]:
    chunks = []
    chunk_id = start_id

    module_pattern = r'(?=(?:Module|MODULE|Unit|UNIT)\s+[1-6IVX]+)'
    parts = re.split(module_pattern, text)

    if len(parts) <= 1:
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

    for part in parts:
        part = part.strip()
        if not part or len(part) < 30:
            continue

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

        if is_syllabus_document(text, doc_name):
            print(f"[Chunker] Syllabus detected: {doc_name} - using smart chunking")
            return extract_syllabus_chunks(text, doc_name)

        print(f"[Chunker] Regular chunking: {doc_name}")
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


_chunker: TextChunker = None


def get_chunker(
    chunk_size: int = CHUNK_SIZE,
    chunk_overlap: int = CHUNK_OVERLAP,
) -> TextChunker:
    global _chunker
    _chunker = TextChunker(chunk_size, chunk_overlap)
    return _chunker