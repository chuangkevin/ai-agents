"""
環境變數載入器
用於安全地載入API金鑰和配置設定
"""
import os
from typing import Optional
from dotenv import load_dotenv

# 載入環境變數
load_dotenv()

class Config:
    """應用程式配置類別"""
    
    # API Keys
    OPENAI_API_KEY: Optional[str] = os.getenv("OPENAI_API_KEY")
    
    # 資料庫設定 (使用 SQLite)
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///ai_agents.db")
    
    # 應用程式設定
    DEBUG: bool = os.getenv("DEBUG", "True").lower() == "true"
    SECRET_KEY: str = os.getenv("SECRET_KEY", "dev-secret-key-change-this")
    HOST: str = os.getenv("HOST", "localhost")
    PORT: int = int(os.getenv("PORT", "8000"))
    
    @classmethod
    def validate_required_keys(cls) -> list[str]:
        """驗證必要的API金鑰是否已設定"""
        missing_keys = []
        
        if not cls.OPENAI_API_KEY:
            missing_keys.append("OPENAI_API_KEY")
            
        return missing_keys
    
    @classmethod
    def get_openai_config(cls) -> dict:
        """取得OpenAI配置"""
        if not cls.OPENAI_API_KEY:
            raise ValueError("OPENAI_API_KEY 未設定")
            
        return {
            "api_key": cls.OPENAI_API_KEY,
            "model": "gpt-3.5-turbo",
            "temperature": 0.7,
            "max_tokens": 1000
        }

# 全域配置實例
config = Config()

# 驗證配置
missing_keys = config.validate_required_keys()
if missing_keys:
    print(f"⚠️  警告: 缺少以下環境變數: {', '.join(missing_keys)}")
    print("請建立 .env 檔案並設定 OPENAI_API_KEY")
