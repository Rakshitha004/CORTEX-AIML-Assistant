"""
Configuration settings for the LLM Student Assistant.
"""
import os
from pathlib import Path

# Project paths
BASE_DIR = Path(__file__).parent.parent
DATA_DIR = BASE_DIR / "data"
PDF_DIR = DATA_DIR / "pdf_documents"
DATABASE_DIR = BASE_DIR / "database"
MODELS_DIR = BASE_DIR / "models"
VECTOR_STORE_DIR = BASE_DIR / "rag" / "vector_store"

# Ensure directories exist
PDF_DIR.mkdir(parents=True, exist_ok=True)
DATABASE_DIR.mkdir(parents=True, exist_ok=True)
VECTOR_STORE_DIR.mkdir(parents=True, exist_ok=True)

# Database settings
DATABASE_PATH = DATABASE_DIR / "students.db"
STUDENTS_CSV_PATH = DATA_DIR / "students.csv"

# Model settings
MODEL_NAME = "mistral"
MODEL_ID = "mistral-7b-instruct-v0.1"
MAX_TOKENS = 512
TEMPERATURE = 0.7
TOP_P = 0.95

# Embeddings settings — Together AI API
EMBEDDING_MODEL = "intfloat/multilingual-e5-large-instruct"
EMBEDDING_DIM = 1024  # intfloat/multilingual-e5-large-instruct embedding dimension

# Vector store settings
VECTOR_DB_PATH = VECTOR_STORE_DIR / "faiss_index"
VECTOR_DB_METADATA_PATH = VECTOR_STORE_DIR / "metadata.pkl"

# RAG settings
CHUNK_SIZE = 800
CHUNK_OVERLAP = 150
TOP_K_CHUNKS = 15

# API settings
API_HOST = "127.0.0.1"
API_PORT = 8000
API_LOG_LEVEL = "info"

# Logging settings
LOG_LEVEL = "INFO"
LOG_FILE = BASE_DIR / "logs" / "app.log"
LOG_FILE.parent.mkdir(parents=True, exist_ok=True)

# Agent settings
INTENT_CATEGORIES = ["student_data", "knowledge", "analysis", "other"]
ROUTER_THRESHOLD = 0.7

# Cache settings
CACHE_ENABLED = True
CACHE_TTL = 3600  # 1 hour in seconds

print(f"Configuration loaded from {Path(__file__)}")