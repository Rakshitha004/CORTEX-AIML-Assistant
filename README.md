# CORTEX - AIML Assistant

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)
![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python&logoColor=white)
![React](https://img.shields.io/badge/React-18-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Live-brightgreen?style=for-the-badge)

> **An intelligent, production-grade AI assistant for the AIML Department at Dayananda Sagar College of Engineering, Bangalore.**

[🌐 Live Demo](https://cortex-aiml-assistant.netlify.app) · [📖 API Docs](https://web-production-e4321.up.railway.app/docs) · [🐛 Report Bug](https://github.com/Rakshitha004/CORTEX-AIML-Assistant/issues)

</div>

---

## What is CORTEX?

CORTEX is a fully deployed, multi-agent AI system that answers natural language questions about the AIML department. It combines two powerful pipelines — a RAG pipeline for department knowledge and a SQL pipeline for student academic data — with multilingual support in 5 Indian languages.

Whether you want to know who the HOD is, what subjects are in semester 3 of the 2020 scheme, or who has the highest CGPA — CORTEX answers instantly.

---

## Demo

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@aiml.edu | admin123 |
| Teacher | teacher@aiml.edu | teacher123 |
| Student | student@aiml.edu | student123 |

---

## Features

- **Advanced RAG Pipeline** — Hybrid Search (BM25 + Pinecone), RRF Fusion, Cross-Encoder Reranking, Query Expansion, Smart Caching
- **Multi-Agent SQL Pipeline** — Natural language to SQL using 4 specialized agents and Qwen3-Coder 480B
- **Vision AI** — Sarvam Vision extracts text from scanned PDFs with OCR support for 23 languages
- **Multilingual TTS** — Translate and speak answers in Kannada, Hindi, Telugu, Tamil, and Malayalam
- **Role-Based Access** — Separate portals for Admin, Teacher, and Student
- **Admin Dashboard** — Real-time metrics, query analytics, grounding scores, and intent distribution
- **Voice Input** — Speak your query using the built-in microphone
- **PDF Chat** — Upload any PDF and ask questions about it

---

## System Architecture

```
┌─────────────────────────────────────────────────┐
│         React.js Frontend (Netlify)             │
│   Chat UI · Dashboard · Voice · Multilingual    │
└────────────────────┬────────────────────────────┘
                     │ HTTPS + JWT
┌────────────────────▼────────────────────────────┐
│         FastAPI Backend (Railway)               │
│                                                 │
│   Intent Agent (Llama 3.3 70B)                 │
│         ↙                    ↘                  │
│   RAG Pipeline          SQL Pipeline           │
│   · Query Expansion     · Table Agent          │
│   · Hybrid Search       · Column Agent         │
│   · RRF Fusion          · SQL Generator        │
│   · Cross-Encoder       · SQL Validator        │
│   · Sarvam Vision       · PostgreSQL           │
│         ↘                    ↙                  │
│      Synthesis Agent (Qwen3-235B)              │
│                   ↓                             │
│      Sarvam Translate + Bulbul TTS             │
└────────────────────────────────────────────────┘
         │              │              │
    Pinecone       PostgreSQL      MongoDB
   (Vectors)     (Student Data)  (Metrics)
```

---

## AI Models

| Agent | Model | Purpose |
|-------|-------|---------|
| Intent Agent | Llama 3.3 70B | Query classification |
| Query Expansion | Llama 3.3 70B | Expand short queries |
| Table Agent | Llama 3.3 70B | Identify SQL tables |
| Column Agent | Llama 3.3 70B | Identify SQL columns |
| SQL Validator | Llama 3.3 70B | Validate SQL syntax |
| SQL Generator | Qwen3-Coder 480B | Generate SQL queries |
| Synthesis | Qwen3-235B | Format final answers |
| Embeddings | multilingual-e5-large | 1024-dim vectors |
| Reranker | ms-marco-MiniLM-L-6 | Cross-encoder reranking |
| Vision | Sarvam Vision | Scanned PDF OCR |
| Translation | sarvam-translate:v1 | Indian language translation |
| TTS | Bulbul v3 | Text to speech |

---

## Tech Stack

**Frontend**
- React.js 18, Tailwind CSS, Framer Motion, GSAP, Lucide React
- Deployed on Netlify

**Backend**
- Python 3.11, FastAPI, LangGraph, JWT Authentication
- Deployed on Railway

**Databases**
- Pinecone — Vector database (3700+ vectors)
- PostgreSQL — Student academic data
- MongoDB Atlas — Metrics and chat history

**AI & APIs**
- Together AI — LLM inference
- Sarvam AI — Vision, Translation, TTS
- Pinecone — Vector storage

---

## Project Structure

```
aiml-department-digital-assistant/
├── backend/
│   ├── api.py                    # FastAPI main app
│   └── agents/
│       ├── intent_agent.py       # Query classification
│       ├── synthesis_agent.py    # Answer formatting
│       ├── query_generator.py    # SQL generation
│       ├── sql_validator_ag.py   # SQL validation
│       └── table_agent.py        # Table identification
├── rag/
│   ├── pdf_loader/loader.py      # PDF loading + Vision AI
│   ├── text_chunker/chunker.py   # Text chunking
│   ├── embeddings/generator.py   # Embedding generation
│   ├── vector_store/faiss_store.py # Pinecone wrapper
│   └── retriever.py              # Hybrid search + reranking
├── config/settings.py            # Configuration
├── uploaded_docs/                # 230+ department PDFs
├── initialize.py                 # Re-indexing script
├── requirements.txt
└── FRONTEND-main/
    └── frontend/src/
        ├── pages/ChatPage.js     # Main chat interface
        └── pages/AdminDashboard.js
```

---

## Getting Started

### Prerequisites
- Python 3.11+
- Node.js 18+
- PostgreSQL
- MongoDB Atlas account
- Pinecone account
- Together AI API key
- Sarvam AI API key

### Backend Setup

```bash
# Clone the repository
git clone https://github.com/Rakshitha004/CORTEX-AIML-Assistant
cd aiml-department-digital-assistant

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env
# Add your API keys to .env
```

### Environment Variables

```env
TOGETHER_API_KEY=your_together_ai_key
PINECONE_API_KEY=your_pinecone_key
MONGO_URL=your_mongodb_url
DATABASE_URL=your_postgresql_url
SECRET_KEY=your_jwt_secret
SARVAM_API_KEY=your_sarvam_key
```

### Index PDFs

```bash
# Add PDFs to uploaded_docs/
python initialize.py
```

### Frontend Setup

```bash
cd FRONTEND-main/frontend
npm install
npm start
```

---

## Sample Queries

**Department Knowledge**
```
"Who is the HOD of AIML department?"
"List all faculty members"
"What subjects are in semester 3 of 2020 scheme?"
"Tell me about Aventus hackathon"
"What are the industry visits by AIML students?"
"What research areas does Dr. Aruna work in?"
```

**Student Academic Data**
```
"Who has the highest CGPA?"
"List top 5 students by CGPA"
"Compare average SGPA across all semesters"
"Show students with CGPA above 9"
"Which subject has the highest failure rate?"
```

**Multilingual**
```
Ask any question → click ಕನ್ನಡ / हिंदी / తెలుగు → hear the answer!
```

---

## Performance

| Metric | Value |
|--------|-------|
| Vectors indexed | 3,713 |
| PDFs processed | 230+ |
| Recall@10 | 1.0 |
| SQL success rate | 100% |
| Average grounding score | 0.60 |
| AI models used | 9 |
| Languages supported | 6 |

---

## Roadmap

- [ ] Streaming responses for better latency
- [ ] HyDE (Hypothetical Document Embedding)
- [ ] Corrective RAG (CRAG) with web search fallback
- [ ] RAGAs evaluation pipeline
- [ ] Data visualization for SQL results
- [ ] Google Scholar live integration
- [ ] Batch/year comparison queries
- [ ] Full accessibility support (WCAG 2.1)

---

## License

Copyright © 2026 Rakshitha and Vrunda. Licensed under the [MIT License](LICENSE).

---

## Acknowledgements

- [Together AI](https://together.ai) for LLM inference
- [Sarvam AI](https://sarvam.ai) for Vision, Translation and TTS
- [Pinecone](https://pinecone.io) for vector storage
- [LangGraph](https://langchain-ai.github.io/langgraph/) for multi-agent orchestration

---

<div align="center">

**Built with ❤️ for AIML Department, DSCE Bangalore · 2025-26**

</div>
