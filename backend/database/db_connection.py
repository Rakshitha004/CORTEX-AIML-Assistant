from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv
from pathlib import Path

# Load .env from backend folder
env_path = Path(__file__).resolve().parent.parent / ".env"
load_dotenv(env_path)

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def test_connection():
    with engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM student_results"))
        for row in result:
            print(row)

def run_sql(query):

    with engine.connect() as connection:

        result = connection.execute(text(query))

        rows = result.fetchall()

        columns = result.keys()

        data = []

        for row in rows:
            data.append(dict(zip(columns, row)))

        return data