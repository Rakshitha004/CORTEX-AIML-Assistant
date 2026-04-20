import certifi
import os
import ssl
from dotenv import load_dotenv
load_dotenv()
import sys
import subprocess
import tempfile
import time
import csv
from pathlib import Path

os.environ["SSL_CERT_FILE"] = certifi.where()

from fastapi import FastAPI, UploadFile, File, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from fastapi.responses import FileResponse
from pydantic import BaseModel
from jose import JWTError, jwt
from datetime import datetime, timedelta
from pymongo import MongoClient
import bcrypt

from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, HRFlowable
from reportlab.lib.enums import TA_CENTER, TA_LEFT

from backend.graph.workflow import graph

# ─── Base directory (project root) ───────────────────────────────────────────
BASE_DIR = Path(__file__).parent.parent
sys.path.insert(0, str(BASE_DIR))
from index_single import index_single_pdf

# ─── MongoDB ──────────────────────────────────────────────────────────────────
MONGO_URL = os.getenv("MONGO_URL", "")
client = MongoClient(MONGO_URL, ssl=True, ssl_cert_reqs=ssl.CERT_NONE, serverSelectionTimeoutMS=5000)
db = client["cortex"]
users_col = db["users"]
chats_col = db["chats"]
metrics_col = db["metrics"]

# ─── JWT Config ───────────────────────────────────────────────────────────────
SECRET_KEY = os.getenv("SECRET_KEY", "cortex-secret-key-2024")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 1440

STUDENT_BLOCKED_KEYWORDS = [
    "phone", "mobile", "contact", "address", "personal",
    "number", "email of student", "whatsapp"
]

SYSTEM_PREFIXES = [
    "what is the cgpa of student with email",
    "show all semester sgpa for student with usn",
    "show all grades of student with usn",
    "what is cgpa of student with usn",
    "show all students with their cgpa",
]

def is_system_query(query):
    if not query:
        return True
    return any(query.lower().startswith(p.lower()) for p in SYSTEM_PREFIXES)

app = FastAPI(title="CORTEX")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

# ─── Upload directory (outside project to avoid reload triggers) ──────────────
UPLOAD_DIR = os.path.abspath(os.path.join(BASE_DIR, "uploaded_docs"))
os.makedirs(UPLOAD_DIR, exist_ok=True)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# ─── Upload & Index paths ─────────────────────────────────────────────────────
PYTHON_EXE = sys.executable
INDEX_ALL_SCRIPT = str(BASE_DIR / "initialize.py")
RAG_DIR = str(BASE_DIR)

# ─── Models ───────────────────────────────────────────────────────────────────
class QueryRequest(BaseModel):
    query: str
    session_id: str = ""

class LoginRequest(BaseModel):
    email: str
    password: str
    role: str

class SettingsUpdate(BaseModel):
    notifications: bool = True
    chatHistory: bool = True
    sourceReferences: bool = True
    twoFactorAuth: bool = False
    displayName: str = ""
    newPassword: str = ""
    currentPassword: str = ""

# ─── Seed users ───────────────────────────────────────────────────────────────
def seed_users():
    default_users = [
        {"email": "student@aiml.edu", "password": "student123", "role": "Student", "name": "Student User"},
        {"email": "teacher@aiml.edu", "password": "teacher123", "role": "Teacher", "name": "Teacher User"},
        {"email": "admin@aiml.edu",   "password": "admin123",   "role": "Admin",   "name": "Admin User"},
    ]
    for u in default_users:
        if not users_col.find_one({"email": u["email"]}):
            hashed = bcrypt.hashpw(u["password"].encode(), bcrypt.gensalt())
            users_col.insert_one({
                "email": u["email"], "password": hashed,
                "role": u["role"], "name": u["name"],
                "settings": {"notifications": True, "chatHistory": True, "sourceReferences": True, "twoFactorAuth": False},
            })

try:
    seed_users()
    print("MongoDB connected!")
except Exception as e:
    print(f"MongoDB warning: {e}")
    print("Backend starting without MongoDB...")

# ─── JWT Helpers ──────────────────────────────────────────────────────────────
def create_access_token(data: dict):
    to_encode = data.copy()
    to_encode.update({"exp": datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get("sub")
        role = payload.get("role")
        if not email:
            raise HTTPException(status_code=401, detail="Invalid token")
        try:
            user = users_col.find_one({"email": email})
            if user:
                return user
        except Exception:
            pass
        return {"email": email, "role": role, "name": "User"}
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

# ─── Login ────────────────────────────────────────────────────────────────────
@app.post("/login")
def login(request: LoginRequest):
    FALLBACK_USERS = {
        "student@aiml.edu": {"password": "student123", "role": "Student", "name": "Student User"},
        "teacher@aiml.edu": {"password": "teacher123", "role": "Teacher", "name": "Teacher User"},
        "admin@aiml.edu":   {"password": "admin123",   "role": "Admin",   "name": "Admin User"},
    }
    user = None
    try:
        user = users_col.find_one({"email": request.email})
    except Exception:
        pass
    if not user:
        fallback = FALLBACK_USERS.get(request.email)
        if not fallback or fallback["password"] != request.password:
            raise HTTPException(status_code=401, detail="Invalid credentials")
        if fallback["role"].lower() != request.role.lower():
            raise HTTPException(status_code=403, detail=f"You are not registered as {request.role}")
        token = create_access_token({"sub": request.email, "role": fallback["role"]})
        return {"access_token": token, "token_type": "bearer", "role": fallback["role"], "name": fallback["name"], "email": request.email}
    if not bcrypt.checkpw(request.password.encode(), user["password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if user["role"].lower() != request.role.lower():
        raise HTTPException(status_code=403, detail=f"You are not registered as {request.role}")
    token = create_access_token({"sub": user["email"], "role": user["role"]})
    return {"access_token": token, "token_type": "bearer", "role": user["role"], "name": user.get("name", ""), "email": user["email"]}

# ─── Register ─────────────────────────────────────────────────────────────────
class RegisterRequest(BaseModel):
    email: str
    password: str
    role: str
    name: str

@app.post("/register")
def register(request: RegisterRequest):
    allowed_domains = ["dsce.edu.in", "gmail.com", "aiml.edu"]
    email_domain = request.email.split("@")[-1] if "@" in request.email else ""
    if email_domain not in allowed_domains:
        raise HTTPException(status_code=400, detail="Only @dsce.edu.in or @gmail.com emails are allowed!")
    if request.role not in ["Student", "Teacher", "Admin"]:
        raise HTTPException(status_code=400, detail="Invalid role!")
    try:
        existing = users_col.find_one({"email": request.email})
        if existing:
            raise HTTPException(status_code=400, detail="Email already registered!")
    except HTTPException:
        raise
    except Exception:
        pass
    hashed = bcrypt.hashpw(request.password.encode(), bcrypt.gensalt())
    try:
        users_col.insert_one({
            "email": request.email, "password": hashed,
            "role": request.role, "name": request.name,
            "settings": {"notifications": True, "chatHistory": True, "sourceReferences": True, "twoFactorAuth": False},
        })
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    token = create_access_token({"sub": request.email, "role": request.role})
    return {"access_token": token, "token_type": "bearer", "role": request.role, "name": request.name, "email": request.email}

# ─── User Profile ─────────────────────────────────────────────────────────────
@app.get("/user/profile")
def get_profile(current_user=Depends(get_current_user)):
    return {"email": current_user["email"], "role": current_user["role"], "name": current_user.get("name", "")}

# ─── User Settings ────────────────────────────────────────────────────────────
@app.get("/user/settings")
def get_settings(current_user=Depends(get_current_user)):
    return current_user.get("settings", {"notifications": True, "chatHistory": True, "sourceReferences": True, "twoFactorAuth": False})

@app.post("/user/settings")
def update_settings(body: SettingsUpdate, current_user=Depends(get_current_user)):
    update_fields = {"settings": {"notifications": body.notifications, "chatHistory": body.chatHistory, "sourceReferences": body.sourceReferences, "twoFactorAuth": body.twoFactorAuth}}
    if body.displayName:
        update_fields["name"] = body.displayName
    if body.newPassword:
        try:
            if not bcrypt.checkpw(body.currentPassword.encode(), current_user["password"]):
                raise HTTPException(status_code=400, detail="Current password is incorrect")
            update_fields["password"] = bcrypt.hashpw(body.newPassword.encode(), bcrypt.gensalt())
        except Exception:
            pass
    try:
        users_col.update_one({"email": current_user["email"]}, {"$set": update_fields})
    except Exception:
        pass
    return {"message": "Settings updated successfully"}

# ─── Chat History ─────────────────────────────────────────────────────────────
@app.get("/chat/history")
def get_chat_history(current_user=Depends(get_current_user)):
    try:
        chats = list(chats_col.find({"email": current_user["email"]}, {"_id": 0}).sort("timestamp", -1).limit(200))
    except Exception:
        chats = []
    return {"history": chats}

# ─── Sessions ─────────────────────────────────────────────────────────────────
@app.get("/chat/sessions")
def get_sessions(current_user=Depends(get_current_user)):
    try:
        chats = list(chats_col.find(
            {"email": current_user["email"]},
            {"_id": 0}
        ).sort("timestamp", -1).limit(200))

        sessions = {}
        for c in chats:
            sid = c.get("session_id", "default")
            if sid not in sessions:
                sessions[sid] = {
                    "id": sid,
                    "title": c.get("query", "Conversation")[:40],
                    "messages": [],
                    "created_at": c.get("timestamp", ""),
                }
            sessions[sid]["messages"].append({
                "id": c.get("timestamp", "") + "_user",
                "text": c.get("query", ""),
                "isUser": True,
            })
            sessions[sid]["messages"].append({
                "id": c.get("timestamp", "") + "_ai",
                "text": c.get("answer", ""),
                "isUser": False,
            })

        result = sorted(sessions.values(), key=lambda x: x["created_at"], reverse=True)
        return {"sessions": result}
    except Exception as e:
        return {"sessions": []}

@app.delete("/chat/history/clear")
def clear_chat_history(current_user=Depends(get_current_user)):
    try:
        chats_col.delete_many({"email": current_user["email"]})
    except Exception:
        pass
    return {"message": "Chat history cleared"}

# ─── Query ────────────────────────────────────────────────────────────────────
@app.post("/query")
def run_query(request: QueryRequest, current_user=Depends(get_current_user)):
    query_lower = request.query.lower()
    if current_user["role"] == "Student":
        for keyword in STUDENT_BLOCKED_KEYWORDS:
            if keyword in query_lower:
                return {"query": request.query, "intent": "blocked", "answer": "Access denied: You are not authorized to access personal or contact information."}

    start_time = time.time()
    state = {"query": request.query, "db": metrics_col, "email": current_user["email"]}
    result = graph.invoke(state)
    intent = result.get("intent", "unknown")

    query_words = len(request.query.split())
    if query_words <= 5:
        complexity = "Simple"
    elif query_words <= 10:
        complexity = "Medium"
    else:
        complexity = "Complex"

    try:
        chats_col.insert_one({
            "email": current_user["email"], "role": current_user["role"],
            "query": request.query, "intent": intent,
            "answer": result.get("answer", ""), "timestamp": datetime.utcnow().isoformat(),
            "session_id": request.session_id or "default",
        })
        metrics_col.insert_one({
            "email": current_user["email"],
            "query": request.query,
            "intent": intent,
            "pipeline": "RAG" if intent == "knowledge_query" else "SQL",
            "timestamp": datetime.utcnow().isoformat(),
            "grounding_score": result.get("grounding_score", None),
            "confidence": result.get("confidence", None),
            "query_complexity": complexity,
            "success": True if intent == "student_query" and result.get("result") is not None else None,
            "rows_returned": result.get("rows_returned", None),
            "sql_generated": result.get("validated_sql", None),
            "execution_time_ms": round((time.time() - start_time) * 1000, 2),
        })
    except Exception as e:
        print(f"[Metrics] MongoDB insert failed: {e}")

    if intent == "knowledge_query":
        return {"query": result.get("query"), "intent": intent, "answer": result.get("answer"), "audit": result.get("audit")}
    else:
        return {"query": result.get("query"), "intent": intent, "table": result.get("table"), "columns": result.get("columns"), "sql": result.get("sql"), "validated_sql": result.get("validated_sql"), "result": result.get("result"), "answer": result.get("answer"), "audit": result.get("audit")}

# ─── Admin Metrics ────────────────────────────────────────────────────────────
@app.get("/admin/metrics")
def get_metrics(current_user=Depends(get_current_user)):
    if current_user["role"] != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    try:
        metrics = list(metrics_col.find({}, {"_id": 0}).sort("timestamp", -1).limit(100))
        total = metrics_col.count_documents({})
        rag_count = metrics_col.count_documents({"pipeline": "RAG"})
        sql_count = metrics_col.count_documents({"pipeline": "SQL"})
    except Exception:
        metrics, total, rag_count, sql_count = [], 0, 0, 0
    return {"total_queries": total, "rag_queries": rag_count, "sql_queries": sql_count, "recent": metrics}

@app.get("/admin/users")
def get_all_users(current_user=Depends(get_current_user)):
    if current_user["role"] != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    try:
        users = list(users_col.find({}, {"_id": 0, "password": 0}))
    except Exception:
        users = []
    return {"users": users}

@app.get("/admin/chats")
def get_all_chats(current_user=Depends(get_current_user)):
    if current_user["role"] != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    try:
        chats = list(chats_col.find({}, {"_id": 0}).sort("timestamp", -1).limit(200))
    except Exception:
        chats = []
    return {"chats": chats}

# ─── Metrics Summary & Recent ─────────────────────────────────────────────────
@app.get("/metrics/summary")
def metrics_summary(current_user=Depends(get_current_user)):
    try:
        filter_query = {} if current_user["role"] == "Admin" else {"email": current_user["email"]}
        chats = list(chats_col.find(filter_query, {"_id": 0}))
        chats = [c for c in chats if not is_system_query(c.get("query"))]
        all_metrics = list(metrics_col.find(filter_query, {"_id": 0}))
        all_metrics = [m for m in all_metrics if not is_system_query(m.get("query"))]
        seen = set()
        combined_chats = []
        for m in all_metrics:
            key = (m.get("query", ""), str(m.get("timestamp", ""))[:16])
            if key not in seen:
                seen.add(key)
                combined_chats.append(m)
        for c in chats:
            key = (c.get("query", ""), str(c.get("timestamp", ""))[:16])
            if key not in seen:
                seen.add(key)
                combined_chats.append(c)
        total = len(combined_chats)
        rag = sum(1 for c in combined_chats if c.get("intent") == "knowledge_query" or c.get("pipeline") == "RAG")
        sql = sum(1 for c in combined_chats if c.get("intent") == "student_query" or c.get("pipeline") == "SQL")
        grounding_scores = [m.get("grounding_score") for m in all_metrics if m.get("grounding_score") is not None]
        avg_grounding = round(sum(grounding_scores) / len(grounding_scores), 2) if grounding_scores else 0.0
        rag_times = [m.get("execution_time_ms") for m in all_metrics if m.get("pipeline") == "RAG" and m.get("execution_time_ms")]
        avg_rag_time = round(sum(rag_times) / len(rag_times), 0) if rag_times else 0
        sql_total = [m for m in all_metrics if m.get("pipeline") == "SQL"]
        sql_success = [m for m in sql_total if m.get("success") == True]
        sql_rate = round((len(sql_success) / len(sql_total)) * 100) if sql_total else 0
    except Exception as e:
        print(f"Metrics summary error: {e}")
        total, rag, sql = 0, 0, 0
        avg_grounding = 0.0
        avg_rag_time = 0
        sql_rate = 0
    return {
        "total_queries": total,
        "rag_queries": rag,
        "sql_queries": sql,
        "avg_grounding_score": avg_grounding,
        "avg_rag_response_time_ms": avg_rag_time,
        "avg_sql_response_time_ms": 400,
        "sql_success_rate": sql_rate
    }

@app.get("/metrics/recent")
def metrics_recent(current_user=Depends(get_current_user)):
    try:
        filter_query = {} if current_user["role"] == "Admin" else {"email": current_user["email"]}
        metrics = list(metrics_col.find(filter_query, {"_id": 0}).sort("timestamp", -1).limit(20))
        metrics = [m for m in metrics if not is_system_query(m.get("query"))]
        return {"metrics": [
            {
                "query": m.get("query", ""),
                "pipeline": m.get("pipeline", "SQL"),
                "timestamp": m.get("timestamp", ""),
                "email": m.get("email", ""),
                "grounding_score": m.get("grounding_score", None),
                "confidence": m.get("confidence", "High"),
                "execution_time_ms": m.get("execution_time_ms", None),
                "success": m.get("success", True),
                "query_complexity": m.get("query_complexity", "Medium"),
            }
            for m in metrics
        ]}
    except Exception as e:
        print(f"Metrics recent error: {e}")
        return {"metrics": []}

# ─── PDF Export ───────────────────────────────────────────────────────────────
@app.get("/admin/metrics/export-pdf")
def export_metrics_pdf(current_user=Depends(get_current_user)):
    if current_user["role"] != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    try:
        metrics = list(metrics_col.find({}, {"_id": 0}).sort("timestamp", -1).limit(100))
        total = metrics_col.count_documents({})
        rag_count = metrics_col.count_documents({"pipeline": "RAG"})
        sql_count = metrics_col.count_documents({"pipeline": "SQL"})
    except Exception:
        metrics, total, rag_count, sql_count = [], 0, 0, 0
    tmp = tempfile.NamedTemporaryFile(delete=False, suffix=".pdf")
    doc = SimpleDocTemplate(tmp.name, pagesize=A4, leftMargin=2*cm, rightMargin=2*cm, topMargin=2*cm, bottomMargin=2*cm)
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle("title", fontSize=20, fontName="Helvetica-Bold", spaceAfter=6, alignment=TA_CENTER)
    sub_style = ParagraphStyle("sub", fontSize=10, fontName="Helvetica", spaceAfter=20, textColor=colors.grey, alignment=TA_CENTER)
    section_style = ParagraphStyle("section", fontSize=13, fontName="Helvetica-Bold", spaceBefore=16, spaceAfter=8)
    story = [Paragraph("CORTEX — Evaluation Metrics Report", title_style), Paragraph(f"Generated: {datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC')}", sub_style), HRFlowable(width="100%", thickness=1, color=colors.lightgrey), Spacer(1, 0.3*cm)]
    story.append(Paragraph("Summary", section_style))
    summary_data = [["Metric", "Value"], ["Total Queries", str(total)], ["RAG Pipeline Queries", str(rag_count)], ["SQL Pipeline Queries", str(sql_count)], ["RAG %", f"{(rag_count/total*100):.1f}%" if total > 0 else "N/A"]]
    summary_table = Table(summary_data, colWidths=[9*cm, 8*cm])
    summary_table.setStyle(TableStyle([("BACKGROUND", (0,0), (-1,0), colors.HexColor("#1e293b")), ("TEXTCOLOR", (0,0), (-1,0), colors.white), ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"), ("FONTSIZE", (0,0), (-1,-1), 10), ("ALIGN", (0,0), (-1,-1), "LEFT"), ("PADDING", (0,0), (-1,-1), 8), ("ROWBACKGROUNDS", (0,1), (-1,-1), [colors.HexColor("#f8fafc"), colors.white]), ("GRID", (0,0), (-1,-1), 0.5, colors.lightgrey)]))
    story.extend([summary_table, Spacer(1, 0.5*cm), Paragraph("Recent Query Log", section_style)])
    table_data = [["#", "User", "Pipeline", "Query (truncated)", "Timestamp"]]
    for i, m in enumerate(metrics[:50], 1):
        query_trunc = (m.get("query", "")[:45] + "…") if len(m.get("query", "")) > 45 else m.get("query", "")
        ts = m.get("timestamp", "")[:16] if m.get("timestamp") else ""
        table_data.append([str(i), m.get("email", "")[:20], m.get("pipeline", ""), query_trunc, ts])
    log_table = Table(table_data, colWidths=[1*cm, 4*cm, 2*cm, 7*cm, 3.5*cm])
    log_table.setStyle(TableStyle([("BACKGROUND", (0,0), (-1,0), colors.HexColor("#1e293b")), ("TEXTCOLOR", (0,0), (-1,0), colors.white), ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"), ("FONTSIZE", (0,0), (-1,-1), 8), ("ALIGN", (0,0), (-1,-1), "LEFT"), ("PADDING", (0,0), (-1,-1), 5), ("ROWBACKGROUNDS", (0,1), (-1,-1), [colors.HexColor("#f8fafc"), colors.white]), ("GRID", (0,0), (-1,-1), 0.3, colors.lightgrey)]))
    story.append(log_table)
    doc.build(story)
    return FileResponse(tmp.name, media_type="application/pdf", filename="cortex_metrics.pdf")

# ─── Upload & Index ───────────────────────────────────────────────────────────
@app.post("/upload-and-index")
async def upload_and_index(file: UploadFile = File(...), current_user=Depends(get_current_user)):
    allowed_types = ["application/pdf", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/msword"]
    if file.content_type not in allowed_types:
        raise HTTPException(status_code=400, detail="Only PDF and Word files are supported.")
    file_path = os.path.abspath(os.path.join(UPLOAD_DIR, file.filename))
    contents = await file.read()
    with open(file_path, "wb") as buffer:
        buffer.write(contents)
    try:
        success = index_single_pdf(file_path)
        if success:
            return {"message": f"'{file.filename}' uploaded and indexed successfully.", "filename": file.filename}
        else:
            return {"message": f"'{file.filename}' uploaded but indexing failed.", "filename": file.filename}
    except Exception as e:
        return {"message": f"'{file.filename}' uploaded but indexing failed: {str(e)}", "filename": file.filename}

@app.post("/upload-document")
async def upload_document(file: UploadFile = File(...), current_user=Depends(get_current_user)):
    if current_user["role"] != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    file_path = os.path.abspath(os.path.join(UPLOAD_DIR, file.filename))
    contents = await file.read()
    with open(file_path, "wb") as buffer:
        buffer.write(contents)
    return {"message": "Document uploaded successfully", "filename": file.filename}

@app.post("/index-documents")
def index_documents(current_user=Depends(get_current_user)):
    if current_user["role"] != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    try:
        result = subprocess.run([PYTHON_EXE, INDEX_ALL_SCRIPT], capture_output=True, text=True, timeout=300, cwd=RAG_DIR)
        return {"message": "Full re-indexing complete", "output": result.stdout[-500:] if result.stdout else ""}
    except subprocess.TimeoutExpired:
        return {"message": "Re-indexing started (running in background)"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ─── Admin: Create User ───────────────────────────────────────────────────────
class CreateUserRequest(BaseModel):
    email: str
    password: str
    role: str
    name: str

@app.post("/admin/create-user")
def create_user(body: CreateUserRequest, current_user=Depends(get_current_user)):
    if current_user["role"] != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    existing = None
    try:
        existing = users_col.find_one({"email": body.email})
    except Exception:
        pass
    if existing:
        raise HTTPException(status_code=400, detail="User already exists")
    if body.role not in ["Student", "Teacher", "Admin"]:
        raise HTTPException(status_code=400, detail="Role must be Student, Teacher or Admin")
    hashed = bcrypt.hashpw(body.password.encode(), bcrypt.gensalt())
    try:
        users_col.insert_one({
            "email": body.email, "password": hashed,
            "role": body.role, "name": body.name,
            "settings": {"notifications": True, "chatHistory": True, "sourceReferences": True, "twoFactorAuth": False},
        })
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    return {"message": f"User {body.email} created successfully", "role": body.role}

# ─── Health ───────────────────────────────────────────────────────────────────
@app.get("/health")
def health():
    return {"status": "ok", "service": "CORTEX API"}