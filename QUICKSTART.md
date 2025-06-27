# 快速開始指南

## 🚀 第一次設定

### 1. 建立虛擬環境並安裝依賴

```bash
# 建立虛擬環境
python -m venv venv

# 啟動虛擬環境 (Windows)
venv\Scripts\activate

# 安裝依賴
pip install -r requirements.txt
```

### 2. 設定環境變數

```bash
# 複製環境變數範本
cp .env.example .env

# 編輯 .env 檔案，填入您的 OpenAI API 金鑰
# OPENAI_API_KEY=sk-your-actual-api-key-here
```

### 3. 初始化資料庫

```bash
python src/init_db.py
```

### 4. 測試基本功能

```bash
python test_basic.py
```

## 💡 使用範例

### 基本使用

```python
from src.agents.dispatcher import AgentDispatcher

# 建立調度器
dispatcher = AgentDispatcher()

# 處理問題
result = dispatcher.process_question("我想學習攝影構圖技巧")

print(f"選擇的專家: {result['expert']}")
print(f"回答: {result['response']}")
```

### 處理反饋

```python
# 假設對話ID為1，用戶給予負面反饋
feedback_result = dispatcher.process_feedback(
    conversation_id=1,
    feedback="negative", 
    feedback_text="不是我要的答案"
)

print(feedback_result)
```

## 📊 目前功能

✅ **基礎功能**
- OpenAI API 整合
- SQLite 資料庫儲存
- 3個專家領域 (攝影、咖啡、鍵盤)
- 關鍵字匹配的智能派發
- 負面反饋檢測
- 對話記錄儲存

## 🔧 故障排除

### 常見問題

1. **ImportError: No module named 'openai'**
   ```bash
   pip install -r requirements.txt
   ```

2. **API 金鑰錯誤**
   - 檢查 `.env` 檔案是否正確設定
   - 確認 OpenAI API 金鑰有效

3. **資料庫錯誤**
   ```bash
   python src/init_db.py
   ```

## 📈 下一步擴展

- [ ] 建立 Web 介面 (Streamlit/FastAPI)
- [ ] 新增更多專家領域
- [ ] 改善問題分類演算法
- [ ] 新增用戶管理功能
- [ ] 實作對話歷史功能
