#!/usr/bin/env python3
"""
簡單的服務啟動腳本
"""
import os
import sys

# 確保在正確的目錄
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# 添加 src 到路徑
sys.path.append('src')

print("🤖 啟動 AI Agent Web 服務...")
print("📁 工作目錄:", os.getcwd())

try:
    # 檢查基本依賴
    import flask
    print("✅ Flask 已安裝")
    
    # 檢查 OpenAI API Key
    from src.config import config
    if config.OPENAI_API_KEY:
        print("✅ OpenAI API Key 已設定")
    else:
        print("⚠️  OpenAI API Key 未設定")
    
    # 啟動應用
    from app import app, init_app
    
    if init_app():
        print("🚀 啟動 Web 服務...")
        print("🌐 服務網址: http://localhost:5000")
        print("📱 前端界面: http://localhost:5000")
        print("🔗 API 健康檢查: http://localhost:5000/api/health")
        print("\n按 Ctrl+C 停止服務...")
        
        app.run(host='0.0.0.0', port=5000, debug=True)
    else:
        print("❌ 初始化失敗")
        
except Exception as e:
    print(f"❌ 啟動失敗: {e}")
    import traceback
    traceback.print_exc()
