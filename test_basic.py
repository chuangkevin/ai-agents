"""
簡單的測試腳本
測試基本功能是否正常運作
"""
import sys
import os

# 將 src 目錄加入 Python 路徑
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src.agents.dispatcher import AgentDispatcher
from src.config import config

def test_basic_functionality():
    """測試基本功能"""
    print("🧪 開始測試基本功能...")
    
    # 檢查配置
    if not config.OPENAI_API_KEY:
        print("❌ OPENAI_API_KEY 未設定，請先設定環境變數")
        return False
    
    print("✅ OpenAI API 金鑰已設定")
    
    # 建立調度器
    try:
        dispatcher = AgentDispatcher()
        print("✅ Agent 調度器建立成功")
    except Exception as e:
        print(f"❌ 建立調度器失敗: {e}")
        return False
    
    # 測試專家列表
    experts = dispatcher.get_available_experts()
    print(f"✅ 可用專家數量: {len(experts)}")
    for expert in experts:
        print(f"   - {expert['name']}: {expert['description']}")
    
    # 測試問題處理
    test_questions = [
        "我想學習攝影構圖技巧",
        "手沖咖啡的水溫應該多少度？",
        "機械鍵盤什麼軸最適合打字？"
    ]
    
    for question in test_questions:
        print(f"\n📝 測試問題: {question}")
        try:
            result = dispatcher.process_question(question)
            if result.get('error'):
                print(f"❌ 處理失敗: {result['error']}")
            else:
                print(f"✅ 選擇專家: {result['expert']}")
                print(f"📋 回答: {result['response'][:100]}...")
        except Exception as e:
            print(f"❌ 處理問題時發生錯誤: {e}")
    
    print("\n🎉 基本功能測試完成！")
    return True

if __name__ == "__main__":
    # 先初始化資料庫
    from src.init_db import main as init_db
    init_db()
    
    # 執行測試
    test_basic_functionality()
