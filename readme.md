# 多領域AI Agent系統

## 專案概述

多領域AI Agent系統是一個智能問答平台，能夠自動識別用戶問題的領域並派發給對應的專家Agent，提供專業且個人化的回答。

## 核心功能

### 1. 智能派發 (Agent Dispatcher)

- 自動分析用戶問題的領域屬性
- 智能選擇最適合的專家Agent
- 支援多專家協作處理複雜問題

### 2. 專業回答 (Domain Experts)

- 各領域專家提供深度專業知識
- 個人化回答風格適應
- 持續學習和知識更新

### 3. 反饋優化 (Feedback System)

- 檢測負面詞彙：不是、不要、不準、不是我要的等
- 接收用戶建議並重新解析問題
- 透過「思考領域專家」優化問題理解

## 專家領域規劃

### 已規劃專家

- 📸 **攝影專家** - 攝影技巧、器材推薦、構圖美學
- 🐱 **貓咪專家** - 貓咪行為、健康照護、品種知識
- ☕ **咖啡專家** - 咖啡豆知識、沖煮技巧、器具推薦
- ⌨️ **鍵盤專家** - 機械鍵盤、軸體特性、DIY組裝
- 👜 **名牌包專家** - 精品包款、搭配建議、真偽辨識
- 🖋️ **鋼筆專家** - 鋼筆品牌、墨水搭配、書寫技巧

### 擴展方向

- 🎵 音樂專家
- 🍷 紅酒專家
- 🏃‍♂️ 運動健身專家
- 💻 程式開發專家

## 技術架構

### 核心組件

```text
用戶輸入 → Agent Dispatcher → Domain Expert → 回答輸出
              ↓                     ↑
         意圖識別模型          知識庫檢索
              ↓                     ↑
         專家選擇邏輯          反饋學習系統
```

### 技術棧選擇

- **框架**: LangChain
- **LLM**: OpenAI GPT-3.5-turbo
- **資料庫**: SQLite
- **後端**: Python FastAPI
- **前端**: Streamlit

## 實作階段

### Phase 1: MVP版本 ✅ (當前階段)

- [x] 建立基礎Agent Dispatcher
- [x] 實作3個核心專家 (攝影、咖啡、鍵盤)
- [x] 基本反饋機制
- [x] SQLite 資料庫整合
- [ ] 簡易Web介面 ✅

## 🐳 Docker 快速啟動

```bash
# 1. 設定環境變數
cp .env.example .env
# 編輯 .env 檔案，填入您的 OpenAI API 金鑰

# 2. 一鍵啟動
docker-compose up --build -d

# 3. 訪問服務
# Web界面: http://localhost:8000
# 健康檢查: http://localhost:8000/api/health
```

**詳細Docker指南**: [DOCKER_GUIDE.md](DOCKER_GUIDE.md)

## 🚀 CI/CD 自動化部署

本專案支援 GitHub Actions 自動構建和推送 Docker 映像到 Docker Hub。

### 快速設定

1. **設定 GitHub Secrets**:
   - `DOCKER_USERNAME`: 您的 Docker Hub 用戶名
   - `DOCKER_PASSWORD`: 您的 Docker Hub Access Token

2. **推送代碼觸發構建**:
   ```bash
   git push origin main
   ```

3. **使用構建的映像**:
   ```bash
   docker pull your-username/ai-agents:latest
   docker run -d -p 8000:8000 --env-file .env your-username/ai-agents:latest
   ```

**詳細CI/CD指南**: [CICD_GUIDE.md](CICD_GUIDE.md)

### Phase 2: 功能完善 (未來規劃)

- [ ] 完成所有6個專家領域
- [ ] 多專家協作機制
- [ ] 進階反饋和學習系統
- [ ] 用戶個人化設定

### Phase 3: 優化擴展 (未來規劃)

- [ ] 效能優化和擴展性改善
- [ ] 多模態支援 (圖片、語音)
- [ ] 新專家領域擴展
- [ ] 移動端應用

## 評估指標

- **準確度**: 問題分派正確率 > 90%
- **滿意度**: 用戶回答滿意度 > 85%
- **響應時間**: 平均回答時間 < 3秒
- **學習效果**: 反饋後改善率 > 70%

## 開發環境設置

**詳細設定請參考 [SETUP.md](SETUP.md)**  
**快速開始請參考 [QUICKSTART.md](QUICKSTART.md)**

```bash
# 1. 建立專案環境
python -m venv venv
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux

# 2. 安裝依賴
pip install -r requirements.txt

# 3. 設定環境變數
cp .env.example .env
# 編輯 .env 檔案，填入您的 OpenAI API 金鑰

# 4. 初始化資料庫
python src/init_db.py

# 5. 測試基本功能
python test_basic.py
```

## 專案結構

```text
ai-agents/
├── src/
│   ├── agents/
│   │   ├── dispatcher.py
│   │   ├── base_expert.py
│   │   └── experts/
│   │       ├── photography_expert.py
│   │       ├── cat_expert.py
│   │       └── ...
│   ├── utils/
│   ├── database/
│   └── api/
├── tests/
├── docs/
├── requirements.txt
└── README.md
```