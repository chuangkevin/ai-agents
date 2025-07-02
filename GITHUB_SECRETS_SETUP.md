# GitHub Secrets 設定指南

## 🚨 修復 Docker 部署錯誤

當前錯誤：`invalid tag "***/ai-agents:main": invalid reference format`

**原因**：GitHub Actions 無法讀取 `DOCKER_USERNAME` Secret

## 🔧 解決步驟

### 1. 確認 Docker Hub 用戶名

1. 登入 [Docker Hub](https://hub.docker.com/)
2. 點擊右上角用戶頭像
3. 查看下拉選單中的用戶名，或前往 [設定頁面](https://hub.docker.com/settings/general) 查看 "Docker ID"

### 2. 建立 Docker Access Token

1. 前往：https://hub.docker.com/settings/security
2. 點擊 **"New Access Token"**
3. 設定：
   - **Token description**: `ai-agents-github-actions`
   - **Access permissions**: `Read, Write, Delete`
4. 點擊 **"Generate"**
5. **複製產生的 Token**（只會顯示一次！）

### 3. 設定 GitHub Secrets

1. 前往：https://github.com/chuangkevin/ai-agents/settings/secrets/actions

2. **新增 DOCKER_USERNAME**：
   - 點擊 **"New repository secret"**
   - **Name**: `DOCKER_USERNAME`
   - **Secret**: `您的Docker Hub用戶名`（不是email！）
   - 點擊 **"Add secret"**

3. **新增 DOCKER_PASSWORD**：
   - 點擊 **"New repository secret"**
   - **Name**: `DOCKER_PASSWORD`
   - **Secret**: `剛才複製的Access Token`
   - 點擊 **"Add secret"**

### 4. 觸發重新部署

設定完成後，有兩種方式觸發部署：

**方式一：推送代碼**
```bash
git commit --allow-empty -m "trigger: 重新觸發Docker部署"
git push
```

**方式二：手動觸發**
1. 前往：https://github.com/chuangkevin/ai-agents/actions
2. 點擊 **"AI Agents Docker CI/CD"**
3. 點擊 **"Run workflow"**
4. 選擇 `main` 分支
5. 點擊 **"Run workflow"**

### 5. 檢查部署狀態

1. **GitHub Actions**：https://github.com/chuangkevin/ai-agents/actions
2. **Docker Hub**：https://hub.docker.com/r/您的用戶名/ai-agents

## 🔍 常見問題

### Q1: 如何確認 Docker Hub 用戶名？
- 登入 Docker Hub，用戶名會顯示在右上角
- 通常不是 email 格式（如：`kevin950805` 而不是 `kevin950805@gmail.com`）

### Q2: Access Token 和密碼有什麼不同？
- **不要使用密碼**！GitHub Actions 需要 Access Token
- Access Token 更安全，可以設定特定權限

### Q3: 如何測試設定是否正確？
- 設定完 Secrets 後，推送任何變更或手動觸發工作流程
- 查看 GitHub Actions 執行結果

## 📝 範例設定

假設您的 Docker Hub 用戶名是 `kevin950805`：

```
DOCKER_USERNAME = kevin950805
DOCKER_PASSWORD = dckr_pat_1234567890abcdef... (Access Token)
```

## ⚠️ 安全提醒

- **絕不在代碼中暴露 Access Token**
- **只在 GitHub Secrets 中設定敏感資訊**
- **定期更換 Access Token**
