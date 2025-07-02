#!/usr/bin/env python3
"""
快速測試系統是否正常運作
"""
import sys
import os

# 添加 src 目錄到路徑
sys.path.append(os.path.join(os.path.dirname(__file__), 'src'))

def test_system():
    """測試系統組件"""
    print("🔍 測試系統組件...")
    
    # 1. 測試模組導入
    try:
        from src.agents.dispatcher import AgentDispatcher
        from src.config import config
        print("✅ 模組導入成功")
    except Exception as e:
        print(f"❌ 模組導入失敗: {e}")
        return False
    
    # 2. 測試資料庫連接
    try:
        dispatcher = AgentDispatcher()
        experts = dispatcher.get_available_experts()
        print(f"✅ 資料庫連接成功，找到 {len(experts)} 位專家")
        for expert in experts:
            print(f"   - {expert['name']}: {expert['description']}")
    except Exception as e:
        print(f"❌ 資料庫連接失敗: {e}")
        return False
    
    # 3. 測試環境設定
    try:
        if config.OPENAI_API_KEY and config.OPENAI_API_KEY != 'your_openai_api_key_here':
            print("✅ OpenAI API Key 已設定")
        else:
            print("⚠️  OpenAI API Key 未設定（預設值）")
            print("💡 請編輯 .env 檔案設定您的 OpenAI API Key")
    except Exception as e:
        print(f"❌ 環境設定檢查失敗: {e}")
    
    # 4. 測試 Flask 應用
    try:
        import app
        print("✅ Flask 應用載入成功")
        print("🚀 準備啟動 Web 服務...")
        return True
    except Exception as e:
        print(f"❌ Flask 應用載入失敗: {e}")
        return False

def main():
    """主程式"""
    print("=" * 50)
    print("🤖 AI Agent 系統測試")
    print("=" * 50)
    
    if test_system():
        print("\n" + "=" * 50)
        print("🎉 系統測試通過！")
        print("=" * 50)
        print("📋 啟動服務的方式:")
        print("1. 執行: python app.py")
        print("2. 或使用: python start_simple.py")
        print("3. 或使用: .\\start.ps1")
        print("\n🌐 服務將在 http://localhost:5000 啟動")
        print("📱 前端界面: http://localhost:5000")
        print("🔌 API 端點: http://localhost:5000/api/")
        
        # 詢問是否要啟動服務
        response = input("\n是否要立即啟動服務? (y/n): ")
        if response.lower() == 'y':
            print("\n🚀 啟動服務中...")
            try:
                import app
                app.app.run(host='0.0.0.0', port=5000, debug=True)
            except KeyboardInterrupt:
                print("\n👋 服務已停止")
            except Exception as e:
                print(f"\n❌ 服務啟動失敗: {e}")
    else:
        print("\n❌ 系統測試失敗，請檢查上述錯誤")

if __name__ == "__main__":
    main()
