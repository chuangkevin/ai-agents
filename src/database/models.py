"""
資料庫模型定義
使用 SQLAlchemy + SQLite
"""
from datetime import datetime
from sqlalchemy import create_engine, Column, Integer, String, Text, DateTime, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from src.config import config

Base = declarative_base()

class Conversation(Base):
    """對話記錄"""
    __tablename__ = "conversations"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_question = Column(Text, nullable=False)
    expert_type = Column(String(50), nullable=False)
    agent_response = Column(Text, nullable=False)
    user_feedback = Column(String(20))  # positive, negative, neutral
    feedback_text = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    is_satisfied = Column(Boolean, default=True)

class ExpertProfile(Base):
    """專家檔案設定"""
    __tablename__ = "expert_profiles"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), unique=True, nullable=False)
    description = Column(Text)
    system_prompt = Column(Text, nullable=False)
    keywords = Column(Text)  # JSON格式儲存關鍵字
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

# 建立資料庫引擎
engine = create_engine(config.DATABASE_URL, echo=config.DEBUG)

# 建立會話工廠
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def create_tables():
    """建立所有資料表"""
    Base.metadata.create_all(bind=engine)
    print("✅ 資料庫表格建立完成")

def get_db():
    """取得資料庫會話"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

if __name__ == "__main__":
    create_tables()
