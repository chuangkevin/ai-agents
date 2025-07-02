"""
資料庫初始化腳本
"""
import sys
import os

# 將 src 目錄加入 Python 路徑
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from database.models import create_tables, SessionLocal, ExpertProfile
import json

def init_expert_profiles():
    """初始化專家檔案"""
    experts_data = [
        {
            "name": "photography",
            "description": "攝影專家 - 攝影技巧、器材推薦、構圖美學",
            "system_prompt": """你是一位專業的攝影專家，擁有豐富的攝影經驗和深厚的技術知識。
你能夠提供關於攝影技巧、器材選擇、構圖美學、後製處理等各方面的專業建議。
請用友善、專業的態度回答用戶的問題，並適時提供實用的技巧和建議。

**回答格式要求：**
- 使用 Markdown 格式組織回答
- 用 ## 或 ### 標示重點主題
- 用 **粗體** 強調重要概念
- 用項目列表 (- 或 1.) 列出步驟或要點
- 適當時使用 `程式碼格式` 標示設定值或專業術語
- 用 > 引用重要提醒或注意事項""",
            "keywords": json.dumps(["攝影", "相機", "鏡頭", "構圖", "光線", "曝光", "景深", "快門", "ISO", "後製", "Photoshop", "Lightroom"])
        },
        {
            "name": "coffee",
            "description": "咖啡專家 - 咖啡豆知識、沖煮技巧、器具推薦",
            "system_prompt": """你是一位專業的咖啡專家，對咖啡豆的產地、處理法、烘焙程度都有深入了解。
你熟悉各種咖啡沖煮方法，包括手沖、義式濃縮、法式壓壺等。
請用熱情、專業的態度分享咖啡知識，幫助用戶提升咖啡品味和沖煮技巧。

**回答格式要求：**
- 使用 Markdown 格式組織回答
- 用 ## 或 ### 標示重點主題
- 用 **粗體** 強調重要概念
- 用項目列表 (- 或 1.) 列出步驟或要點
- 適當時使用 `程式碼格式` 標示溫度、時間等數值
- 用 > 引用重要提醒或注意事項""",
            "keywords": json.dumps(["咖啡", "咖啡豆", "手沖", "義式", "濃縮", "拿鐵", "卡布奇諾", "烘焙", "研磨", "咖啡機", "沖煮"])
        },
        {
            "name": "keyboard",
            "description": "鍵盤專家 - 機械鍵盤、軸體特性、DIY組裝",
            "system_prompt": """你是一位機械鍵盤專家，對各種軸體特性、鍵盤結構、DIY組裝都非常了解。
你能夠根據用戶的使用需求推薦合適的鍵盤，並提供客製化建議。
請用專業、細心的態度回答問題，幫助用戶找到最適合的鍵盤配置。

**回答格式要求：**
- 使用 Markdown 格式組織回答
- 用 ## 或 ### 標示重點主題
- 用 **粗體** 強調重要概念
- 用項目列表 (- 或 1.) 列出步驟或要點
- 適當時使用 `程式碼格式` 標示型號或規格
- 用 > 引用重要提醒或注意事項""",
            "keywords": json.dumps(["鍵盤", "機械鍵盤", "軸體", "青軸", "紅軸", "茶軸", "黑軸", "客製化", "鍵帽", "PCB", "衛星軸", "潤軸"])
        }
    ]
    
    db = SessionLocal()
    try:
        # 檢查是否已有資料
        existing_count = db.query(ExpertProfile).count()
        if existing_count > 0:
            print(f"✅ 專家檔案已存在 ({existing_count} 個)")
            return
        
        # 建立專家檔案
        for expert_data in experts_data:
            expert = ExpertProfile(**expert_data)
            db.add(expert)
        
        db.commit()
        print("✅ 專家檔案初始化完成")
        
    except Exception as e:
        print(f"❌ 初始化專家檔案時發生錯誤: {e}")
        db.rollback()
    finally:
        db.close()

def main():
    """主初始化函數"""
    print("🚀 開始初始化資料庫...")
    
    # 建立資料表
    create_tables()
    
    # 初始化專家檔案
    init_expert_profiles()
    
    print("✅ 資料庫初始化完成！")

if __name__ == "__main__":
    main()
