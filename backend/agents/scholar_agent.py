import time

# ── Faculty with known Google Scholar IDs (fastest — direct lookup) ──────────
FACULTY_SCHOLAR_IDS = {
    "Dr. Aruna M G": "CQY3VBUAAAAJ",
    "Dr. Reshma S": "5z-YP7AAAAAJ",
}

# ── Faculty to search by name (no Scholar ID in PDF) ────────────────────────
FACULTY_SEARCH_NAMES = [
    ("Dr. Vindhya P Malagi", "Vindhya Malagi DSCE Bangalore"),
    ("Dr. Kusumika Krori Dutta", "Kusumika Krori Dutta DSCE Bangalore"),
    ("Anupama Vijaykumar", "Anupama Vijaykumar DSCE Bangalore"),
    ("Prof. Kavya D N", "Kavya D N DSCE Bangalore"),
    ("Deepshree Buchade", "Deepshree Buchade DSCE Bangalore"),
    ("Ensteih Silvia", "Ensteih Silvia DSCE Bangalore"),
    ("Ramya K", "Ramya K DSCE Bangalore"),
]

RESEARCH_KEYWORDS = [
    "research publication", "publications", "research paper",
    "journal", "paper published", "google scholar",
    "research work", "published paper", "research by faculty",
    "faculty research", "papers by", "research areas",
    "who has published", "latest research"
]

def is_research_query(query: str) -> bool:
    q = query.lower()
    return any(kw in q for kw in RESEARCH_KEYWORDS)

def fetch_by_scholar_id(name: str, scholar_id: str, max_papers: int = 3) -> dict:
    try:
        from scholarly import scholarly
        author = scholarly.search_author_id(scholar_id)
        author = scholarly.fill(author, sections=["publications"])
        papers = []
        for pub in author.get("publications", [])[:max_papers]:
            bib = pub.get("bib", {})
            papers.append({
                "title": bib.get("title", "Unknown Title"),
                "year": bib.get("pub_year", "N/A"),
                "venue": bib.get("venue", bib.get("journal", "")),
                "citations": pub.get("num_citations", 0)
            })
        return {"name": name, "papers": papers, "success": True}
    except Exception as e:
        print(f"[Scholar ID Lookup Failed] {name}: {e}")
        return {"name": name, "papers": [], "success": False}

def fetch_by_name_search(display_name: str, search_query: str, max_papers: int = 3) -> dict:
    try:
        from scholarly import scholarly
        search_results = scholarly.search_author(search_query)
        author = next(search_results, None)
        if not author:
            return {"name": display_name, "papers": [], "success": False}
        author = scholarly.fill(author, sections=["publications"])
        papers = []
        for pub in author.get("publications", [])[:max_papers]:
            bib = pub.get("bib", {})
            papers.append({
                "title": bib.get("title", "Unknown Title"),
                "year": bib.get("pub_year", "N/A"),
                "venue": bib.get("venue", bib.get("journal", "")),
                "citations": pub.get("num_citations", 0)
            })
        return {"name": display_name, "papers": papers, "success": True}
    except Exception as e:
        print(f"[Scholar Name Search Failed] {display_name}: {e}")
        return {"name": display_name, "papers": [], "success": False}

def fetch_scholar_publications(query: str) -> str:
    if not is_research_query(query):
        return ""

    print(f"[Scholar] Research query detected — fetching live publications...")
    results = []

    # Step 1: Known Scholar IDs (fast)
    for name, scholar_id in FACULTY_SCHOLAR_IDS.items():
        print(f"[Scholar] Fetching {name} by ID...")
        result = fetch_by_scholar_id(name, scholar_id, max_papers=3)
        if result["success"] and result["papers"]:
            results.append(result)
        time.sleep(1)

    # Step 2: Name search — limit to 3 to avoid Railway timeout
    for display_name, search_query in FACULTY_SEARCH_NAMES[:3]:
        print(f"[Scholar] Searching {display_name} by name...")
        result = fetch_by_name_search(display_name, search_query, max_papers=3)
        if result["success"] and result["papers"]:
            results.append(result)
        time.sleep(1)

    if not results:
        return "\n\n---\n🔬 **Live Google Scholar search attempted but no results found.**"

    output = "\n\n---\n## 🔬 Live Research Publications (Google Scholar)\n\n"
    for faculty in results:
        output += f"### {faculty['name']}\n"
        for i, paper in enumerate(faculty["papers"], 1):
            year = f" ({paper['year']})" if paper['year'] != "N/A" else ""
            venue = f" — *{paper['venue']}*" if paper['venue'] else ""
            citations = f" | {paper['citations']} citations" if paper['citations'] > 0 else ""
            output += f"{i}. **{paper['title']}**{year}{venue}{citations}\n"
        output += "\n"

    output += "*Results fetched live from Google Scholar*\n"
    return output