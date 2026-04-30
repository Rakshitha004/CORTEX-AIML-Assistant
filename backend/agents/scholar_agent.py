import time
import requests

# ── Semantic Scholar API (free, no key, works on cloud servers) ──────────────
SEMANTIC_SCHOLAR_API = "https://api.semanticscholar.org/graph/v1"

# ── Faculty list with search queries ────────────────────────────────────────
FACULTY_LIST = [
    {"name": "Dr. Vindhya P Malagi",      "query": "Vindhya Malagi"},
    {"name": "Dr. Aruna M G",             "query": "Aruna M G DSCE Bangalore"},
    {"name": "Dr. Reshma S",              "query": "Reshma S DSCE Bangalore"},
    {"name": "Dr. Kusumika Krori Dutta",  "query": "Kusumika Krori Dutta"},
    {"name": "Anupama Vijaykumar",        "query": "Anupama Vijaykumar DSCE"},
    {"name": "Prof. Kavya D N",           "query": "Kavya D N DSCE Bangalore"},
    {"name": "Deepshree Buchade",         "query": "Deepshree Buchade"},
    {"name": "Ensteih Silvia",            "query": "Ensteih Silvia DSCE"},
    {"name": "Ramya K",                   "query": "Ramya K DSCE Bangalore"},
]

# ── Keywords that trigger Scholar search ─────────────────────────────────────
RESEARCH_KEYWORDS = [
    "research publication", "publications", "research paper",
    "journal", "paper published", "google scholar",
    "research work", "published paper", "research by faculty",
    "faculty research", "papers by", "research areas",
    "who has published", "latest research", "publication of"
]


def is_research_query(query: str) -> bool:
    q = query.lower()
    return any(kw in q for kw in RESEARCH_KEYWORDS)


def search_faculty_papers(faculty_name: str, search_query: str, max_papers: int = 3) -> dict:
    """Search Semantic Scholar for a faculty member's papers"""
    try:
        # Step 1: Search for the author
        resp = requests.get(
            f"{SEMANTIC_SCHOLAR_API}/author/search",
            params={
                "query": search_query,
                "fields": "name,paperCount,papers.title,papers.year,papers.venue,papers.citationCount,papers.externalIds"
            },
            timeout=10
        )

        if resp.status_code != 200:
            print(f"[Semantic Scholar] API error {resp.status_code} for {faculty_name}")
            return {"name": faculty_name, "papers": [], "success": False}

        data = resp.json()
        authors = data.get("data", [])

        if not authors:
            print(f"[Semantic Scholar] No author found for {faculty_name}")
            return {"name": faculty_name, "papers": [], "success": False}

        # Take first matching author
        author = authors[0]
        raw_papers = author.get("papers", [])

        # Sort by year descending, take top N
        sorted_papers = sorted(
            raw_papers,
            key=lambda p: int(p.get("year") or 0),
            reverse=True
        )[:max_papers]

        papers = []
        for p in sorted_papers:
            title = p.get("title", "Unknown Title")
            year = p.get("year", "N/A")
            venue = p.get("venue", "")
            citations = p.get("citationCount", 0)

            # Build DOI/URL if available
            ext_ids = p.get("externalIds", {})
            doi = ext_ids.get("DOI", "")
            url = f"https://doi.org/{doi}" if doi else ""

            papers.append({
                "title": title,
                "year": year,
                "venue": venue,
                "citations": citations,
                "url": url
            })

        print(f"[Semantic Scholar] Found {len(papers)} papers for {faculty_name}")
        return {"name": faculty_name, "papers": papers, "success": True}

    except Exception as e:
        print(f"[Semantic Scholar Failed] {faculty_name}: {e}")
        return {"name": faculty_name, "papers": [], "success": False}


def detect_specific_faculty(query: str) -> list:
    """Check if query mentions a specific faculty — search only them"""
    q = query.lower()
    matched = []
    for faculty in FACULTY_LIST:
        # Check if any part of faculty name is in query
        name_parts = faculty["name"].lower().replace("dr.", "").replace("prof.", "").strip().split()
        if any(part in q for part in name_parts if len(part) > 3):
            matched.append(faculty)
    return matched


def fetch_scholar_publications(query: str) -> str:
    """
    Main function — fetches live research publications from Semantic Scholar.
    Only triggers for research-related queries.
    Returns formatted markdown string to append to RAG answer.
    """
    if not is_research_query(query):
        return ""

    print(f"[Scholar] Research query detected — fetching from Semantic Scholar...")

    # Check if query mentions specific faculty
    specific_faculty = detect_specific_faculty(query)

    # If specific faculty mentioned → search only them
    # If general query → search top 3 faculty (to avoid timeout)
    faculty_to_search = specific_faculty if specific_faculty else FACULTY_LIST[:3]

    results = []
    for faculty in faculty_to_search:
        print(f"[Scholar] Searching {faculty['name']}...")
        result = search_faculty_papers(faculty["name"], faculty["query"], max_papers=3)
        if result["success"] and result["papers"]:
            results.append(result)
        time.sleep(0.5)  # small delay to be polite to API

    if not results:
        return "\n\n---\n🔬 **No live research results found from Semantic Scholar.**"

    # ── Format results as markdown ──
    output = "\n\n---\n## 🔬 Live Research Publications (Semantic Scholar)\n\n"

    for faculty in results:
        output += f"### {faculty['name']}\n"
        for i, paper in enumerate(faculty["papers"], 1):
            year = f" ({paper['year']})" if paper['year'] and paper['year'] != "N/A" else ""
            venue = f" — *{paper['venue']}*" if paper['venue'] else ""
            citations = f" | {paper['citations']} citations" if paper['citations'] and paper['citations'] > 0 else ""
            link = f" [[Link]]({paper['url']})" if paper['url'] else ""
            output += f"{i}. **{paper['title']}**{year}{venue}{citations}{link}\n"
        output += "\n"

    output += "*Results fetched live from Semantic Scholar API*\n"
    return output