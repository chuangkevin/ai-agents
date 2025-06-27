# 環境設定指南

## 🔐 API 金鑰設定

### 1. 複製環境變數範本

```bash
cp .env.example .env
```

### 2. 編輯 .env 檔案

在 `.env` 檔案中填入您的 OpenAI API 金鑰：

```bash
# 必要設定 - OpenAI API
OPENAI_API_KEY=sk-your-actual-openai-api-key-here

# 應用程式設定
DEBUG=True
SECRET_KEY=your_secret_key_here
HOST=localhost
PORT=8000

# 資料庫設定 (使用 SQLite，無需額外設定)
DATABASE_URL=sqlite:///ai_agents.db
```

### 3. 取得 OpenAI API 金鑰

1. 前往 [OpenAI Platform](https://platform.openai.com/api-keys)
2. 登入您的帳號
3. 點選 "Create new secret key"
4. 複製 API 金鑰到 `.env` 檔案

## 🚀 快速開始

### 1. 建立虛擬環境

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# macOS/Linux
source venv/bin/activate
```

### 2. 安裝依賴

```bash
pip install -r requirements.txt
```

### 3. 驗證設定

```bash
python -c "from src.config import config; print('✅ 配置載入成功')"
```

## ⚠️ 安全提醒

1. **絕對不要**將 `.env` 檔案提交到 Git
2. **絕對不要**在程式碼中硬編碼 API 金鑰
3. 定期更換 API 金鑰
4. 監控 API 使用量，避免超額費用

## 🔍 故障排除

### 找不到 API 金鑰

```bash
# 檢查 .env 檔案是否存在
dir .env

# 檢查環境變數是否載入
python -c "import os; print(os.getenv('OPENAI_API_KEY'))"
```

### ModuleNotFoundError

```bash
# 確認虛擬環境已啟動
where python

# 重新安裝依賴
pip install -r requirements.txt
```

## 📝 範例使用

```python
from src.config import config

# 檢查API金鑰是否設定
if config.OPENAI_API_KEY:
    print("✅ OpenAI API 金鑰已設定")
else:
    print("❌ 請設定 OPENAI_API_KEY")

# 取得OpenAI配置
openai_config = config.get_openai_config()
print(f"模型: {openai_config['model']}")
```
