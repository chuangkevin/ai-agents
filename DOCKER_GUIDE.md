# 🐳 Docker 運行完整指南

AI Agent 系統 Docker 部署指南

## 🎯 快速開始

### 1. 環境準備

確保您已安裝：
- **Docker Desktop** (Windows/macOS)
- **Docker Engine** (Linux)
- **Git** (用於克隆專案)

### 2. 克隆專案

```bash
git clone https://github.com/chuangkevin/ai-agents.git
cd ai-agents
```

### 3. 設定環境變數

```bash
# 複製環境變數範本
cp .env.example .env

# 編輯 .env 檔案，填入您的 OpenAI API 金鑰
notepad .env  # Windows
nano .env     # Linux/macOS
```

**重要**: 確保在 `.env` 檔案中設定：
```env
OPENAI_API_KEY=your_openai_api_key_here
```

## 🚀 運行方法

### 方法1: 使用 Docker Compose (推薦)

```bash
# 一鍵啟動 - 構建並運行
docker-compose up --build -d

# 檢查服務狀態
docker-compose ps

# 查看日誌
docker-compose logs -f
```

### 方法2: 使用 Docker 命令

```bash
# 1. 構建映像
docker build -t ai-agents .

# 2. 運行容器
docker run -d \
  --name ai-agents \
  -p 8000:8000 \
  --env-file .env \
  ai-agents
```

## 🌐 訪問服務

服務啟動後，可通過以下方式訪問：

- **Web 界面**: http://localhost:8000
- **健康檢查**: http://localhost:8000/api/health
- **API 文檔**: http://localhost:8000/docs (如果啟用)

## 📋 Docker 命令速查

### 基本操作

```bash
# 啟動服務 (後台運行)
docker-compose up -d

# 重新構建並啟動
docker-compose up --build -d

# 停止服務
docker-compose down

# 重啟服務
docker-compose restart

# 查看容器狀態
docker-compose ps

# 查看日誌
docker-compose logs -f ai-agents
```

### 進階操作

```bash
# 進入容器
docker-compose exec ai-agents bash

# 重新構建映像 (清除快取)
docker-compose build --no-cache

# 停止並移除所有容器、網路、映像
docker-compose down --rmi all --volumes

# 只停止不刪除
docker-compose stop

# 只啟動已停止的容器
docker-compose start
```

## 🔧 配置說明

### Docker Compose 設定

```yaml
services:
  ai-agents:
    build: .
    ports:
      - "8000:8000"           # 主機:容器 端口映射
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - HOST=0.0.0.0
      - PORT=8000
      - DEBUG=False
    volumes:
      - ./ai_agents.db:/app/ai_agents.db  # 資料庫持久化
    restart: unless-stopped    # 自動重啟策略
```

### 環境變數

| 變數名 | 描述 | 預設值 |
|--------|------|--------|
| `OPENAI_API_KEY` | OpenAI API 金鑰 | **必填** |
| `HOST` | 服務綁定地址 | `0.0.0.0` |
| `PORT` | 服務端口 | `8000` |
| `DEBUG` | 除錯模式 | `False` |

## 🛠️ 常見問題

### Q: SSL 憑證驗證失敗
**症狀**: `SSL: CERTIFICATE_VERIFY_FAILED`
**解決**: Dockerfile 已配置信任主機，無需額外設定

### Q: 端口被占用
**症狀**: `bind: address already in use`
**解決**: 
```bash
# 檢查端口使用情況
netstat -ano | findstr :8000  # Windows
lsof -i :8000                 # Linux/macOS

# 修改端口映射
docker-compose up -p 8001:8000 -d
```

### Q: 容器無法啟動
**解決步驟**:
1. 檢查日誌: `docker-compose logs ai-agents`
2. 確認 `.env` 檔案設定正確
3. 確認 Docker Desktop 正在運行
4. 重新構建: `docker-compose build --no-cache`

### Q: 資料庫初始化失敗
**解決**:
```bash
# 重新初始化資料庫
docker-compose exec ai-agents python src/init_db.py

# 或者刪除資料庫重新建立
rm ai_agents.db
docker-compose restart
```

## 📊 效能監控

### 查看資源使用情況

```bash
# 查看容器資源使用
docker stats ai-agents-ai-agents-1

# 查看容器詳細信息
docker inspect ai-agents-ai-agents-1
```

### 健康檢查

```bash
# 手動健康檢查
curl http://localhost:8000/api/health

# 應該返回:
# {"message":"AI Agent 服務運行正常","status":"healthy"}
```

## 🔄 更新流程

### 更新應用程式碼

```bash
# 1. 拉取最新代碼
git pull origin main

# 2. 重新構建並啟動
docker-compose up --build -d

# 3. 驗證更新
curl http://localhost:8000/api/health
```

### 備份資料

```bash
# 備份資料庫
cp ai_agents.db ai_agents.db.backup.$(date +%Y%m%d_%H%M%S)

# 或使用 Docker 卷備份
docker run --rm -v ai-agents_data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data
```

## 🚀 生產部署建議

### 1. 使用 Docker Swarm 或 Kubernetes
### 2. 配置反向代理 (Nginx)
### 3. 設定 SSL/TLS 憑證
### 4. 實施日誌聚合和監控
### 5. 定期備份資料庫

## 📝 注意事項

1. **安全性**: 
   - 絕對不要將 `.env` 檔案提交到版本控制
   - 生產環境請使用強密碼和加密通信

2. **效能**:
   - 預設配置適用於開發環境
   - 生產環境請調整 worker 數量和記憶體限制

3. **網路**:
   - 確保防火牆允許 8000 端口
   - 企業網路可能需要配置代理

## 🆘 支援

如遇問題，請參考：
- 📖 [主要文檔](README.md)
- 🚀 [快速開始指南](QUICKSTART.md)  
- 🔧 [部署指南](DEPLOYMENT.md)
- 💰 [成本分析](COST_ANALYSIS.md)

---

**享受您的 AI Agent 容器化體驗！** 🎉
