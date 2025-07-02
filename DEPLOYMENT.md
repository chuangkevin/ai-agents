# 🚀 AI Agents 部署指南

本指南提供多種部署方式，讓您可以將 AI Agents 系統部署到不同的環境。

## 📋 部署前準備

### 1. 環境要求
- Python 3.8+ (本地部署)
- Docker & Docker Compose (容器部署)
- 有效的 OpenAI API 金鑰

### 2. 設定 API 金鑰
確保 `.env` 檔案中有有效的 OPENAI_API_KEY：
```env
OPENAI_API_KEY=sk-proj-your-api-key-here
```

---

## 🏠 本地開發部署

### 快速啟動
```bash
# 1. 安裝依賴
pip install -r requirements.txt

# 2. 初始化資料庫
python src/init_db.py

# 3. 啟動服務
python app.py
```

服務將在 http://localhost:8000 啟動

### 開發模式特點
- ✅ 熱重載
- ✅ 除錯模式
- ✅ 即時日誌
- ✅ 快速迭代

---

## 🐳 Docker 容器部署

### 單容器部署
```bash
# 1. 建構映像
docker build -t ai-agents .

# 2. 執行容器
docker run -d \
  --name ai-agents \
  -p 8000:8000 \
  --env-file .env \
  -v $(pwd)/ai_agents.db:/app/ai_agents.db \
  ai-agents
```

### Docker Compose 部署（推薦）
```bash
# 一鍵部署
docker-compose up -d

# 檢查狀態
docker-compose ps

# 查看日誌
docker-compose logs -f
```

### Windows 一鍵部署
```cmd
# 執行 Windows 部署腳本
deploy.bat
```

### Linux/Mac 一鍵部署
```bash
# 執行部署腳本
chmod +x deploy.sh
./deploy.sh
```

---

## ☁️ 雲端部署選項

### 1. Heroku 部署

#### 準備檔案
建立 `Procfile`：
```
web: gunicorn --bind 0.0.0.0:$PORT app:app
```

#### 部署步驟
```bash
# 1. 登入 Heroku
heroku login

# 2. 建立應用
heroku create your-ai-agents-app

# 3. 設定環境變數
heroku config:set OPENAI_API_KEY=your-api-key

# 4. 部署
git add .
git commit -m "Deploy to Heroku"
git push heroku main

# 5. 初始化資料庫
heroku run python src/init_db.py
```

### 2. DigitalOcean App Platform

#### 建立 `.do/app.yaml`：
```yaml
name: ai-agents
services:
- name: web
  source_dir: /
  github:
    repo: your-username/ai-agents
    branch: main
  run_command: gunicorn --bind 0.0.0.0:8080 app:app
  environment_slug: python
  instance_count: 1
  instance_size_slug: basic-xxs
  envs:
  - key: OPENAI_API_KEY
    value: your-api-key
    type: SECRET
  http_port: 8080
```

### 3. AWS EC2 部署

#### 使用 Docker 在 EC2 上部署：
```bash
# 1. 連接到 EC2 實例
ssh -i your-key.pem ubuntu@your-ec2-ip

# 2. 安裝 Docker
sudo apt update
sudo apt install docker.io docker-compose -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# 3. 複製程式碼
git clone your-repo-url
cd ai-agents

# 4. 設定環境變數
cp .env.example .env
nano .env

# 5. 部署
docker-compose up -d
```

### 4. Google Cloud Run

#### 部署到 Cloud Run：
```bash
# 1. 建構並推送映像
gcloud builds submit --tag gcr.io/your-project-id/ai-agents

# 2. 部署到 Cloud Run
gcloud run deploy ai-agents \
  --image gcr.io/your-project-id/ai-agents \
  --platform managed \
  --region asia-east1 \
  --allow-unauthenticated \
  --set-env-vars OPENAI_API_KEY=your-api-key
```

---

## 🔧 生產環境配置

### 1. 環境變數設定
```env
# 生產環境設定
OPENAI_API_KEY=your-api-key
DEBUG=False
HOST=0.0.0.0
PORT=8000
SECRET_KEY=your-secret-key-here

# 資料庫設定
DATABASE_URL=sqlite:///ai_agents.db
```

### 2. 反向代理設定 (Nginx)
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 3. SSL 憑證 (Let's Encrypt)
```bash
# 安裝 Certbot
sudo apt install certbot python3-certbot-nginx

# 取得憑證
sudo certbot --nginx -d your-domain.com
```

---

## 📊 監控與維護

### 1. 健康檢查
```bash
# API 健康檢查
curl http://localhost:8000/api/health

# Docker 容器狀態
docker-compose ps
```

### 2. 日誌管理
```bash
# 查看應用日誌
docker-compose logs -f

# 查看特定時間範圍日誌
docker-compose logs --since 2h
```

### 3. 資料庫備份
```bash
# 備份 SQLite 資料庫
cp ai_agents.db backup/ai_agents_$(date +%Y%m%d_%H%M%S).db
```

---

## 🔒 安全性建議

### 1. API 金鑰安全
- ✅ 使用環境變數存儲
- ✅ 定期更換 API 金鑰
- ✅ 限制 API 金鑰權限

### 2. 網路安全
- ✅ 使用 HTTPS
- ✅ 設定防火牆規則
- ✅ 定期更新依賴套件

### 3. 存取控制
- ✅ 考慮添加身份驗證
- ✅ 設定請求速率限制
- ✅ 記錄和監控 API 使用

---

## 🚀 快速部署命令

### 本地開發
```bash
pip install -r requirements.txt && python src/init_db.py && python app.py
```

### Docker 部署
```bash
docker-compose up -d
```

### 檢查服務
```bash
curl http://localhost:8000/api/health
```

---

## 🆘 故障排除

### 常見問題

1. **API 金鑰錯誤**
   - 檢查 `.env` 檔案中的金鑰是否正確
   - 確認金鑰有足夠的配額

2. **端口被占用**
   - 更改 `.env` 中的 `PORT` 設定
   - 或停止占用端口的程序

3. **資料庫錯誤**
   - 重新執行 `python src/init_db.py`
   - 檢查資料庫檔案權限

4. **Docker 建構失敗**
   - 確認 Docker 服務正在運行
   - 清理 Docker 快取：`docker system prune`

### 獲取幫助
- 檢查應用日誌
- 查看 Docker 容器狀態
- 驗證環境變數設定

---

**🎉 恭喜！您的 AI Agents 系統已準備好部署！**
