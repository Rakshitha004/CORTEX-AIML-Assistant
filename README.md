# CORTEX - AIML Assistant

<div align="center">

![CORTEX](https://img.shields.io/badge/CORTEX-AIML%20Assistant-blueviolet?style=for-the-badge&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python&logoColor=white)
![React](https://img.shields.io/badge/React-18-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Pinecone](https://img.shields.io/badge/Pinecone-Vector%20DB-00C084?style=for-the-badge)
![Railway](https://img.shields.io/badge/Railway-Deployed-0B0D0E?style=for-the-badge&logo=railway&logoColor=white)

**An AI-powered department assistant for the AIML Department at Dayananda Sagar College of Engineering, Bangalore.**

[🌐 Live Demo](https://cortex-aiml-assistant.netlify.app) • [📖 API Docs](https://web-production-e4321.up.railway.app/docs)

</div>

---

## 👥 Team

| Name | USN |
|------|-----|
| Rakshitha | 1DS22AI041 |
| Vrunda M | 1DS22AI060 |
| Dhanyashree | 1DS22AI012 |
| Sonu Kumar | 1DS22AI053 |

**Guide:** Dr. Reshma S
**Co-Guide:** Mr. Poornapragna · Mr. Shomron
**Department:** Artificial Intelligence & Machine Learning
**College:** Dayananda Sagar College of Engineering, Bangalore
**Batch:** 2022–26

---

## 📌 About CORTEX

CORTEX is a production-deployed, intelligent department assistant that answers natural language queries using two powerful pipelines:

- 🧠 **RAG Pipeline** — Retrieves answers from 230+ department PDFs (faculty, research, events, schemes, syllabi)
- 🗃️ **SQL Pipeline** — Queries structured student academic data (CGPA, SGPA, grades)
- 🌐 **Multilingual TTS** — Translates and speaks answers in 5 Indian languages

---

## 🚀 Live Demo

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@aiml.edu | admin123 |
| Teacher | teacher@aiml.edu | teacher123 |
| Student | student@aiml.edu | student123 |

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────┐
│           Frontend — React.js + Tailwind CSS            │
│     Netlify · Chat UI · Admin Dashboard · Voice Input   │
└────────────────────────┬────────────────────────────────┘
                         │ HTTPS
┌────────────────────────▼────────────────────────────────┐
│              FastAPI Backend — Railway                   │
│         JWT Auth · LangGraph Multi-Agent Workflow       │
│                                                         │
│        ┌──────────────────────────────────────┐         │
│        │     Intent Agent (Llama 3.3 70B)     │         │
│        └──────────┬───────────────────────────┘         │
│                   │                                     │
│       ┌───────────▼──────────────┐                      │
│       │                          │                      │
│  ┌────▼──────────┐  ┌────────────▼──────────┐           │
│  │  RAG Pipeline  │  │     SQL Pipeline      │           │
│  │                │  │                       │           │
│  │ Query Expansion│  │ Table Agent           │           │
│  │ Hybrid Search  │  │ Column Agent          │           │
│  │ BM25 + Pinecone│  │ SQL Generator (Qwen3) │           │
│  │ RRF Fusion     │  │ SQL Validator         │           │
│  │ Reranking      │  │ PostgreSQL            │           │
│  │ Smart Cache    │  │                       │           │
│  └────────┬───────┘  └────────────┬──────────┘           │
│           └──────────┬────────────┘                      │
│                      │                                   │
│          ┌───────────▼───────────┐                       │
│          │    Synthesis Agent    │                       │
│          │      Qwen3-235B       │                       │
│          └───────────┬───────────┘                       │
│                      │                                   │
│     ┌────────────────▼──────────────────┐                │
│     │  Sarvam AI — Translate + TTS      │                │
│     │ sarvam-translate:v1 · bulbul:v3   │                │
│     └───────────────────────────────────┘                │
└─────────────────────────────────────────────────────────┘
        │                │                │
 ┌──────▼─────┐  ┌───────▼──────┐  ┌─────▼───────┐
 │  Pinecone  │  │  PostgreSQL  │  │   MongoDB   │
 │ Vector DB  │  │ Student Data │  │  Metrics +  │
 │3700+vectors│  │  CGPA/SGPA   │  │   History   │
 └────────────┘  └──────────────┘  └─────────────┘
```

---

## 🤖 AI Models Used

| Agent | Model | Purpose |
|-------|-------|---------|
| Intent Agent | Llama 3.3 70B | Query classification |
| Query Expansion | Llama 3.3 70B | Expand short queries |
| Table Agent | Llama 3.3 70B | Identify SQL tables |
| Column Agent | Llama 3.3 70B | Identify SQL columns |
| SQL Validator | Llama 3.3 70B | Validate SQL queries |
| SQL Generator | Qwen3-Coder 480B | Generate SQL queries |
| RAG Synthesis | Qwen3-235B | Format RAG answers |
| Embeddings | multilingual-e5-large | 1024-dim vectors |
| Reranker | ms-marco-MiniLM-L-6 | Cross-encoder reranking |
| Vision AI | Sarvam Vision | Scanned PDF extraction |
| Translation | sarvam-translate:v1 | Indian language translation |
| TTS | Bulbul v3 | Text to speech |

---

## 🌟 Key Features

### 🧠 Advanced RAG Pipeline
- **Hybrid Search** — BM25 keyword + Pinecone vector search with RRF fusion
- **Query Expansion** — Short queries expanded using LLM for better retrieval
- **Cross-Encoder Reranking** — Results reranked for maximum relevance
- **Smart Caching** — MongoDB-based query cache for instant repeated answers
- **Vision AI** — Sarvam Vision extracts text from scanned PDFs with OCR

### 🗃️ SQL Pipeline
- **Multi-agent** — Separate agents for table, column, generation, validation
- **Qwen3-Coder** — State-of-the-art code model for SQL generation
- **Auto-validation** — SQL validated before execution
- **Natural language** — Plain English to SQL automatically

### 🌐 Multilingual Support
| Language | Code | TTS Speaker |
|----------|------|-------------|
| Kannada | kn-IN | Shruti |
| Hindi | hi-IN | Ritu |
| Telugu | te-IN | Kavitha |
| Tamil | ta-IN | Priya |
| Malayalam | ml-IN | Roopa |
| English | en-IN | Priya |

### 👥 Role-Based Access Control
- **Admin** — Full access + analytics dashboard
- **Teacher** — Query access + department insights
- **Student** — Query access only

### 📊 Admin Dashboard
- Real-time query metrics
- Query complexity tracking
- Intent distribution
- Grounding score monitoring
- Recent query history

---

## 🛠️ Tech Stack

### Backend
| Technology | Purpose |
|------------|---------|
| Python 3.11 | Core language |
| FastAPI | REST API framework |
| LangGraph | Multi-agent workflow |
| Together AI | LLM inference |
| Pinecone | Vector database |
| PostgreSQL | Student data |
| MongoDB Atlas | Metrics + chat history |
| Sarvam AI | Vision + Translation + TTS |
| pdfplumber | PDF text extraction |
| sentence-transformers | Cross-encoder reranking |

### Frontend
| Technology | Purpose |
|------------|---------|
| React.js 18 | UI framework |
| Tailwind CSS | Styling |
| Framer Motion | Animations |
| GSAP | Advanced animations |
| react-markdown | Markdown rendering |
| Lucide React | Icons |

### Infrastructure
| Service | Purpose |
|---------|---------|
| Railway | Backend deployment |
| Netlify | Frontend deployment |
| Pinecone | Vector storage |
| MongoDB Atlas | NoSQL storage |
| GitHub | Version control |

---

## 📁 Project Structure

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
│   ├── pdf_loader/
│   │   └── loader.py             # PDF loading + Sarvam Vision
│   ├── text_chunker/
│   │   └── chunker.py            # Text chunking
│   ├── embeddings/
│   │   └── generator.py          # Together AI embeddings
│   ├── vector_store/
│   │   └── faiss_store.py        # Pinecone wrapper
│   └── retriever.py              # Hybrid search + reranking
├── config/
│   └── settings.py               # Configuration
├── uploaded_docs/                # 230+ department PDFs
├── initialize.py                 # Re-indexing script
├── requirements.txt
└── FRONTEND-main/
    └── frontend/
        └── src/
            ├── pages/
            │   ├── ChatPage.js
            │   └── AdminDashboard.js
            └── context/
```

---

## ⚙️ Setup & Installation

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
# Clone repository
git clone https://github.com/Rakshitha004/CORTEX-AIML-Assistant
cd aiml-department-digital-assistant

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
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

## 📊 Performance Metrics

| Metric | Value |
|--------|-------|
| Total Vectors | 3,713 |
| PDFs Indexed | 230+ |
| Recall@10 | 1.0 |
| MRR | 1.0 |
| SQL Success Rate | 100% |
| Avg Grounding Score | 0.67 |
| Supported Languages | 6 |
| AI Models | 9 |

---

## 🎯 Sample Queries

### RAG Queries
```
"Who is the HOD of AIML department?"
"List all faculty members"
"What are the industry visits by AIML students?"
"Tell me about Aventus hackathon"
"What subjects are in semester 3 of 2020 scheme?"
"What research areas does Dr. Aruna work in?"
```

### SQL Queries
```
"Who has highest CGPA?"
"List top 5 students by CGPA"
"Compare average SGPA across all semesters"
"Show students with CGPA above 9"
"Which subject has highest failure rate?"
```

### Multilingual
```
Ask any question → click ಕನ್ನಡ/हिंदी/తెలుగు → 🔊 Speak
```

---

## 🔮 Future Enhancements

- [ ] HyDE (Hypothetical Document Embedding)
- [ ] CRAG (Corrective RAG with web fallback)
- [ ] Streaming responses
- [ ] RAGAs evaluation pipeline
- [ ] Data visualization for SQL results
- [ ] Google Scholar live integration
- [ ] Batch/year-wise comparison queries
- [ ] Full accessibility (WCAG 2.1)

---

## 📄 License

Copyright (c) 2026 Rakshitha and Vrunda

Licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">

**Built with ❤️ by Team CORTEX · AIML Dept, DSCE Bangalore · 2022–26**

![Made with Python](https://img.shields.io/badge/Made%20with-Python-blue?style=flat-square&logo=python)
![Powered by AI](https://img.shields.io/badge/Powered%20by-AI-purple?style=flat-square)
![Deployed on Railway](https://img.shields.io/badge/Deployed%20on-Railway-black?style=flat-square&logo=railway)

</div>
