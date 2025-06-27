"""
基礎專家 Agent 類別
"""
from typing import Dict, Any
from openai import OpenAI
from src.config import config

class BaseExpert:
    """基礎專家類別"""
    
    def __init__(self, name: str, system_prompt: str):
        self.name = name
        self.system_prompt = system_prompt
        self.client = OpenAI(api_key=config.OPENAI_API_KEY)
        
    def generate_response(self, user_question: str) -> str:
        """生成回答"""
        try:
            response = self.client.chat.completions.create(
                model="gpt-3.5-turbo",
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
