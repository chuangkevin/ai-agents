"""
Agent 調度器
負責分析用戶問題並選擇合適的專家
"""
import json
import re
from typing import Optional, List, Dict
from src.agents.base_expert import BaseExpert
from src.database.models import SessionLocal, ExpertProfile, Conversation

class AgentDispatcher:
    """Agent 調度器"""
    
    def __init__(self):
        self.experts = {}
        self._load_experts()
    
    def _load_experts(self):
        """從資料庫載入專家"""
        db = SessionLocal()
        try:
            expert_profiles = db.query(ExpertProfile).filter(ExpertProfile.is_active == True).all()
            for profile in expert_profiles:
                expert = BaseExpert(profile.name, profile.system_prompt)
                self.experts[profile.name] = {
                    'agent': expert,
                    'keywords': json.loads(profile.keywords) if profile.keywords else [],
                    'description': profile.description
                }
            print(f"✅ 載入了 {len(self.experts)} 個專家")
        finally:
            db.close()
    
    def _calculate_keyword_score(self, question: str, keywords: List[str]) -> int:
        """計算關鍵字匹配分數"""
        question_lower = question.lower()
        score = 0
        
        for keyword in keywords:
            if keyword.lower() in question_lower:
                score += 1
        
        return score
    
    def _detect_negative_feedback(self, text: str) -> bool:
        """檢測負面反饋詞彙"""
        negative_words = [
            "不是", "不要", "不準", "不對", "不是我要的", 
            "錯誤", "不正確", "不符合", "不滿意", "重新"
        ]
        
        text_lower = text.lower()
        for word in negative_words:
            if word in text_lower:
                return True
        
        return False
    
    def select_expert(self, question: str) -> Optional[str]:
        """選擇最適合的專家"""
        if not self.experts:
            return None
        
        best_expert = None
        best_score = 0
        
        for expert_name, expert_info in self.experts.items():
            score = self._calculate_keyword_score(question, expert_info['keywords'])
            if score > best_score:
                best_score = score
                best_expert = expert_name
        
        # 如果沒有匹配的關鍵字，預設選擇第一個專家
        if best_expert is None:
            best_expert = list(self.experts.keys())[0]
        
        return best_expert
    
    def process_question(self, question: str, user_id: str = "anonymous") -> Dict:
        """處理用戶問題"""
        # 選擇專家
        expert_name = self.select_expert(question)
        
        if not expert_name or expert_name not in self.experts:
            return {
                "error": "無法找到合適的專家來回答您的問題",
                "expert": None,
                "response": None
            }
        
        # 取得專家回答
        expert_agent = self.experts[expert_name]['agent']
        response = expert_agent.generate_response(question)
        
        # 記錄對話
        self._save_conversation(question, expert_name, response)
        
        return {
            "expert": expert_name,
            "expert_description": self.experts[expert_name]['description'],
            "response": response,
            "error": None
        }
    
    def process_feedback(self, conversation_id: int, feedback: str, feedback_text: str = "") -> Dict:
        """處理用戶反饋"""
        # 檢測是否為負面反饋
        is_negative = self._detect_negative_feedback(feedback_text or feedback)
        
        # 更新資料庫記錄
        db = SessionLocal()
        try:
            conversation = db.query(Conversation).filter(Conversation.id == conversation_id).first()
            if conversation:
                conversation.user_feedback = "negative" if is_negative else "positive"
                conversation.feedback_text = feedback_text
                conversation.is_satisfied = not is_negative
                db.commit()
                
                if is_negative:
                    # 如果是負面反饋，可以重新處理問題
                    return {
                        "status": "feedback_received",
                        "message": "收到您的反饋，讓我重新為您解答",
                        "suggest_retry": True
                    }
                else:
                    return {
                        "status": "feedback_received",
                        "message": "感謝您的反饋！",
                        "suggest_retry": False
                    }
            else:
                return {"error": "找不到對話記錄"}
        
        except Exception as e:
            return {"error": f"處理反饋時發生錯誤: {str(e)}"}
        finally:
            db.close()
    
    def _save_conversation(self, question: str, expert_name: str, response: str):
        """儲存對話記錄"""
        db = SessionLocal()
        try:
            conversation = Conversation(
                user_question=question,
                expert_type=expert_name,
                agent_response=response
            )
            db.add(conversation)
            db.commit()
        except Exception as e:
            print(f"儲存對話記錄時發生錯誤: {e}")
        finally:
            db.close()
    
    def get_available_experts(self) -> List[Dict]:
        """取得可用的專家列表"""
        return [
            {
                "name": name,
                "description": info['description']
            }
            for name, info in self.experts.items()
        ]
