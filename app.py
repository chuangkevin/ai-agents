"""
Flask Web 應用程式
提供 REST API 接口供前端調用
"""
from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import os
import sys

# 將 src 目錄加入 Python 路徑
sys.path.append(os.path.join(os.path.dirname(__file__), 'src'))

from src.agents.dispatcher import AgentDispatcher
from src.config import config

app = Flask(__name__)
CORS(app)  # 允許跨域請求

# 全域調度器
dispatcher = None

def init_app():
    """初始化應用程式"""
    global dispatcher
    try:
        dispatcher = AgentDispatcher()
        print("✅ AI Agent 系統初始化成功")
        return True
    except Exception as e:
        print(f"❌ 初始化失敗: {e}")
        return False

@app.route('/')
def index():
    """首頁"""
    return render_template('index.html')

@app.route('/api/health')
def health_check():
    """健康檢查"""
    return jsonify({
        "status": "healthy",
        "message": "AI Agent 服務運行正常"
    })

@app.route('/api/experts')
def get_experts():
    """取得可用專家列表"""
    global dispatcher
    try:
        # 確保 dispatcher 已初始化
        if dispatcher is None:
            dispatcher = AgentDispatcher()
        
        experts = dispatcher.get_available_experts()
        return jsonify({
            "success": True,
            "experts": experts
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

@app.route('/api/ask', methods=['POST'])
def ask_question():
    """處理問題"""
    global dispatcher
    try:
        # 確保 dispatcher 已初始化
        if dispatcher is None:
            dispatcher = AgentDispatcher()
            
        data = request.get_json()
        
        if not data or 'question' not in data:
            return jsonify({
                "success": False,
                "error": "請提供問題內容"
            }), 400
        
        question = data['question'].strip()
        if not question:
            return jsonify({
                "success": False,
                "error": "問題不能為空"
            }), 400
        
        # 處理問題
        result = dispatcher.process_question(question)
        
        if result.get('error'):
            return jsonify({
                "success": False,
                "error": result['error']
            }), 500
        
        return jsonify({
            "success": True,
            "expert": result['expert'],
            "expert_description": result['expert_description'],
            "response": result['response']
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": f"處理請求時發生錯誤: {str(e)}"
        }), 500

@app.route('/api/feedback', methods=['POST'])
def submit_feedback():
    """提交用戶反饋"""
    try:
        data = request.get_json()
        
        if not data or 'conversation_id' not in data or 'feedback' not in data:
            return jsonify({
                "success": False,
                "error": "請提供對話ID和反饋內容"
            }), 400
        
        conversation_id = data['conversation_id']
        feedback = data['feedback']
        feedback_text = data.get('feedback_text', '')
        
        # 處理反饋
        result = dispatcher.process_feedback(conversation_id, feedback, feedback_text)
        
        return jsonify({
            "success": True,
            "message": "反饋已記錄"
        })
        
    except Exception as e:
        return jsonify({
            "success": False,
            "error": f"處理反饋時發生錯誤: {str(e)}"
        }), 500

if __name__ == '__main__':
    print("🚀 啟動 AI Agent Web 服務...")
    
    # 初始化應用程式
    if not init_app():
        print("❌ 應用程式初始化失敗，退出...")
        sys.exit(1)
    
    # 從環境變數取得配置
    host = os.getenv('HOST', '0.0.0.0')
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('DEBUG', 'True').lower() == 'true'
    
    print(f"🌐 服務地址: http://{host}:{port}")
    print("📖 API 文檔:")
    print("   GET  /api/health     - 健康檢查")
    print("   GET  /api/experts    - 取得專家列表")
    print("   POST /api/ask        - 提問")
    print("   POST /api/feedback   - 提交反饋")
    
    app.run(host=host, port=port, debug=debug)
