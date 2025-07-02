"""
基礎專家 Agent 類別
"""
from typing import Dict, Any
from openai import OpenAI
import httpx
from src.config import config

class BaseExpert:
    """基礎專家類別"""
    
    def __init__(self, name: str, system_prompt: str):
        self.name = name
        self.system_prompt = system_prompt
        
        # 建立跳過SSL驗證的HTTP客戶端（僅用於測試）
        http_client = httpx.Client(verify=False)
        self.client = OpenAI(
            api_key=config.OPENAI_API_KEY,
            http_client=http_client
        )
        
    def generate_response(self, user_question: str) -> str:
        """生成回答"""
        try:
            response = self.client.chat.completions.create(
                model="gpt-4o-mini",  # 使用最便宜的模型 (GPT-4.1 nano 的對應模型)
                messages=[
                    {"role": "system", "content": self.system_prompt},
                    {"role": "user", "content": user_question}
                ],
                temperature=0.7,
                max_tokens=1000
            )
            
            return response.choices[0].message.content.strip()
            
        except Exception as e:
            return f"抱歉，處理您的問題時發生錯誤：{str(e)}"
    
    def get_info(self) -> Dict[str, Any]:
        """取得專家資訊"""
        return {
            "name": self.name,
            "system_prompt": self.system_prompt
        }
