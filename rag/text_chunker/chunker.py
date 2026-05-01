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

ROMAN_TO_NUM = {
    "I": "1st", "II": "2nd", "III": "3rd", "IV": "4th",
    "V": "5th", "VI": "6th", "VII": "7th", "VIII": "8th"
}

NUM_TO_ROMAN = {v: k for k, v in ROMAN_TO_NUM.items()}

YEAR_MAP = {"18": "2018", "19": "2019", "20": "2020", "21": "2021", "22": "2022"}


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
            if single_chars / len(words) > 0.5:
                continue
        clean_lines.append(line)
    return '\n'.join(clean_lines)


def detect_year_from_text(text: str, doc_name: str) -> str:
    """Detect scheme year from doc name or content."""
    doc_lower = doc_name.lower()
    for year in ["2022", "2021", "2020", "2018"]:
        if year in doc_lower:
            return year
    # Try from content
    match = re.search(r'\b(2018|2019|2020|2021|2022)\b', text[:500])
    if match:
        return match.group(1)
    return ""


def extract_semester_blocks(text: str) -> List[tuple]:
    """
    Split text into (semester_name, block_text) tuples.
    Returns list of (sem_roman, sem_num, block_text).
    """
    # Split on semester headings
    pattern = r'((?:VIII|VII|VI|IV|V|III|II|I)\s+SEMESTER)'
    parts = re.split(pattern, text, flags=re.IGNORECASE)

    blocks = []
    i = 0
    while i < len(parts):
        part = parts[i].strip()
        # Check if this part is a semester heading
        sem_match = re.match(r'^(VIII|VII|VI|IV|V|III|II|I)\s+SEMESTER$', part, re.IGNORECASE)
        if sem_match and i + 1 < len(parts):
            roman = sem_match.group(1).upper()
            sem_num = ROMAN_TO_NUM.get(roman, roman)
            block = parts[i + 1] if i + 1 < len(parts) else ""
            blocks.append((roman, sem_num, block))
            i += 2
        else:
            i += 1

    return blocks


def extract_subjects_from_block(block: str, sem_num: str, year: str, doc_name: str) -> List[str]:
    """
    Extract individual subject rows from a semester block.
    Returns list of subject strings like '22AI51 Data Science'.
    """
    subjects = []

    # Pattern to match subject rows: course code followed by subject name
    # Matches: 22AI51, 22AIL54, 22RM56, 22ES57, 22NS58, 22AI55X etc.
    subject_pattern = re.compile(
        r'\b(\d{2}[A-Z]{2,4}L?\d{2}X?)\s+([A-Z][A-Za-z0-9\s\-–&,/()]+?)(?=\s+(?:TD:|PSB:|PS:|3|2|1|0)\s|\s+\d\s+\d|\n|$)',
        re.MULTILINE
    )

    seen_codes = set()
    for match in subject_pattern.finditer(block):
        code = match.group(1).strip()
        name = match.group(2).strip()

        # Clean up name
        name = re.sub(r'\s+', ' ', name).strip()
        name = re.sub(r'\s*[-–]\s*$', '', name).strip()

        # Skip if too short or looks like garbage
        if len(name) < 3 or len(name) > 80:
            continue
        if code in seen_codes:
            continue

        # Skip elective option rows (3-digit codes like 22AI551) for the main list
        # but still include them labeled as electives
        is_elective_option = bool(re.match(r'\d{2}[A-Z]{2,4}\d{3}', code))

        seen_codes.add(code)
        subjects.append((code, name, is_elective_option))

    return subjects


def extract_syllabus_chunks(text: str, doc_name: str) -> List[Dict[str, Any]]:
    """Main syllabus chunking — creates one chunk per semester with all subjects."""
    text = clean_pdf_text(text)
    chunks = []
    safe_doc = re.sub(r'[^a-zA-Z0-9]', '_', doc_name)
    chunk_id = 0

    year = detect_year_from_text(text, doc_name)

    # Extract semester blocks
    semester_blocks = extract_semester_blocks(text)

    if not semester_blocks:
        # Fallback: treat whole doc as one chunk
        logger.warning(f"[Chunker] No semester blocks found in {doc_name}, falling back")
        chunks.append({
            "id": f"{safe_doc}_{chunk_id}",
            "doc_name": doc_name,
            "content": text[:CHUNK_SIZE],
            "length": len(text[:CHUNK_SIZE]),
        })
        return chunks

    for roman, sem_num, block in semester_blocks:
        if not block.strip():
            continue

        # Extract subjects from this semester block
        subjects = extract_subjects_from_block(block, sem_num, year, doc_name)

        # Build the main semester chunk content
        header = f"Scheme: {year} | Semester: {sem_num} | {roman} SEMESTER"

        # Core subjects (2-digit codes)
        core_subjects = [(c, n) for c, n, is_elec in subjects if not is_elec]
        # Elective options (3-digit codes)
        elective_subjects = [(c, n) for c, n, is_elec in subjects if is_elec]

        # Build content string
        content_lines = [header, ""]

        if core_subjects:
            content_lines.append("Core Subjects:")
            for code, name in core_subjects:
                content_lines.append(f"{code} {name}")

        if elective_subjects:
            content_lines.append("")
            content_lines.append("Elective Options:")
            for code, name in elective_subjects:
                content_lines.append(f"{code} {name}")

        # Also include raw block text for context (truncated)
        content_lines.append("")
        content_lines.append("--- Raw Content ---")
        content_lines.append(block[:1000])

        content = '\n'.join(content_lines)

        chunks.append({
            "id": f"{safe_doc}_{chunk_id}",
            "doc_name": doc_name,
            "content": content,
            "length": len(content),
        })
        chunk_id += 1

        logger.info(f"[Chunker] {doc_name} | {roman} SEMESTER | {len(core_subjects)} core + {len(elective_subjects)} elective subjects")

    # Also chunk remaining content (syllabus details, modules etc.)
    # Split by subject patterns for detailed syllabus
    subject_patterns = [
        r'(?=(?:PCC|IPCC|BSC|PCCL|PEC|AEC|SEC|HSMC|OEC|ESC|SCR)\s+\d{2}[A-Z]{2,3}\d{2,3})',
        r'(?=(?:Course Code|Subject Code)\s*[:\|])',
        r'(?=Module\s+[1-6]\s*[:\|])',
        r'(?=UNIT\s+[IVX]+\s*[:\|])',
    ]
    combined_pattern = '|'.join(subject_patterns)
    detail_parts = re.split(combined_pattern, text)

    for part in detail_parts:
        part = part.strip()
        if not part or len(part) < 100:
            continue

        # Detect which semester this detail belongs to
        sem_match = re.search(r'\b(VIII|VII|VI|IV|V|III|II|I)\s+SEMESTER\b', part[:200], re.IGNORECASE)
        sem_context = ""
        if sem_match:
            roman = sem_match.group(1).upper()
            sem_num = ROMAN_TO_NUM.get(roman, roman)
            sem_context = f"Scheme: {year} | Semester: {sem_num} | "

        header = extract_subject_header(part, year)
        if sem_context and sem_context not in header:
            header = sem_context + header

        if len(part) <= CHUNK_SIZE:
            content = f"{header}\n{part}" if header and header not in part else part
            chunks.append({
                "id": f"{safe_doc}_{chunk_id}",
                "doc_name": doc_name,
                "content": content,
                "length": len(content),
            })
            chunk_id += 1
        else:
            sub_chunks = split_by_modules(part, header, safe_doc, doc_name, chunk_id)
            chunks.extend(sub_chunks)
            chunk_id += len(sub_chunks)

    logger.info(f"[Syllabus Chunker] '{doc_name}' -> {len(chunks)} total chunks")
    return chunks


def extract_subject_header(text: str, year: str = "") -> str:
    lines = text.split('\n')[:8]
    header_lines = []
    scheme_info = ""

    course_match = re.search(r'\b(\d{2})(AI|MA|HS|NS|PE|RM|ES)(\d)[A-Z0-9]{0,6}\b', text[:500])
    if course_match:
        detected_year = YEAR_MAP.get(course_match.group(1), course_match.group(1))
        sem_map = {
            "1": "1st", "2": "2nd", "3": "3rd", "4": "4th",
            "5": "5th", "6": "6th", "7": "7th", "8": "8th"
        }
        sem = sem_map.get(course_match.group(3), course_match.group(3))
        scheme_info = f"Scheme: {detected_year or year} | Semester: {sem}"

    sem_heading_match = re.search(
        r'\b(I|II|III|IV|V|VI|VII|VIII)\s+SEMESTER\b',
        text[:300], flags=re.IGNORECASE
    )
    if sem_heading_match and not scheme_info:
        sem = ROMAN_TO_NUM.get(sem_heading_match.group(1).upper(), sem_heading_match.group(1))
        scheme_info = f"Scheme: {year} | Semester: {sem}" if year else f"Semester: {sem}"

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
    def __init__(self, chunk_size: int = CHUNK_SIZE, chunk_overlap: int = CHUNK_OVERLAP):
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


def get_chunker(chunk_size: int = CHUNK_SIZE, chunk_overlap: int = CHUNK_OVERLAP) -> TextChunker:
    global _chunker
    _chunker = TextChunker(chunk_size, chunk_overlap)
    return _chunker