# 🚀 GitHub Actions Docker CI/CD 設定指南

AI Agents 專案的自動化 Docker 映像構建和部署流程。

## 📋 功能特色

- ✅ **自動觸發**: 推送到 `main` 分支或建立標籤時自動執行
- ✅ **多平台支援**: 同時構建 `linux/amd64` 和 `linux/arm64` 映像
- ✅ **智能標籤**: 根據分支、標籤和提交SHA自動生成映像標籤
- ✅ **安全掃描**: 使用 Trivy 進行漏洞掃描
- ✅ **快取優化**: 使用 GitHub Actions 快取加速構建
- ✅ **手動觸發**: 支援 workflow_dispatch 手動執行

## 🔧 設定步驟

### 1. 建立 Docker Hub 帳號

1. 前往 [Docker Hub](https://hub.docker.com/) 註冊帳號
2. 記錄您的用戶名 (將用於 DOCKER_USERNAME)
3. 建立 Personal Access Token:
   - 登入 Docker Hub
   - 前往 Account Settings > Security
   - 點選 "New Access Token"
   - 輸入描述名稱 (例如: "GitHub Actions")
   - 複製生成的 Token (將用於 DOCKER_PASSWORD)

### 2. 設定 GitHub Secrets

在您的 GitHub 專案中設定以下 Secrets:

1. 前往 GitHub 專案頁面
2. 點選 **Settings** > **Secrets and variables** > **Actions**
3. 點選 **New repository secret** 並新增:

| Secret 名稱 | 描述 | 範例值 |
|-------------|------|--------|
| `DOCKER_USERNAME` | Docker Hub 用戶名 | `your-dockerhub-username` |
| `DOCKER_PASSWORD` | Docker Hub Access Token | `dckr_pat_xxxxxxxxxxxxx` |

### 3. 工作流程檔案

專案包含兩個 GitHub Actions 工作流程:

#### 主要工作流程: `ai-agents-docker.yml`
- **觸發條件**: 推送到 main 分支、建立標籤、手動觸發
- **功能**: 構建多平台映像、推送到 Docker Hub、安全掃描

#### 通用工作流程: `docker-build-push.yml`
- **觸發條件**: 推送到 main/develop 分支、PR、標籤
- **功能**: 通用 Docker 構建流程，包含 attestation

## 🏷️ 映像標籤策略

自動生成的標籤格式:

| 觸發條件 | 標籤格式 | 範例 |
|----------|----------|------|
| 推送到 main | `latest`, `main-<sha>` | `latest`, `main-abc1234` |
| 推送到其他分支 | `<branch>`, `<branch>-<sha>` | `develop`, `develop-abc1234` |
| 建立標籤 | `<tag>`, `<major>.<minor>`, `<major>` | `v1.2.3`, `1.2`, `1` |

## 🚀 使用方式

### 自動觸發

1. **推送到 main 分支**:
   ```bash
   git push origin main
   ```

2. **建立版本標籤**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

### 手動觸發

1. 前往 GitHub 專案的 **Actions** 頁面
2. 選擇 "AI Agents Docker CI/CD" 工作流程
3. 點選 **Run workflow**
4. 選擇分支並點選 **Run workflow**

## 📥 拉取映像

構建完成後，可以使用以下命令拉取映像:

```bash
# 拉取最新版本
docker pull your-dockerhub-username/ai-agents:latest

# 拉取特定標籤
docker pull your-dockerhub-username/ai-agents:v1.0.0

# 運行容器
docker run -d \
  --name ai-agents \
  -p 8000:8000 \
  --env-file .env \
  your-dockerhub-username/ai-agents:latest
```

## 🔍 監控和除錯

### 查看建置狀態

1. 前往 GitHub 專案的 **Actions** 頁面
2. 檢視最新的工作流程執行狀態
3. 點選特定執行查看詳細日誌

### 常見問題

#### ❌ Docker Hub 登入失敗
**錯誤**: `Error: Cannot perform an interactive login from a non TTY device`

**解決方案**:
1. 確認 `DOCKER_USERNAME` 和 `DOCKER_PASSWORD` 已正確設定
2. 檢查 Docker Hub Access Token 是否有效
3. 確認用戶名拼寫正確

#### ❌ 權限不足
**錯誤**: `denied: requested access to the resource is denied`

**解決方案**:
1. 確認 Docker Hub 用戶名正確
2. 檢查 Access Token 權限設定
3. 驗證映像名稱格式: `username/repository:tag`

#### ❌ 多平台構建失敗
**錯誤**: `multiple platforms feature is currently not supported`

**解決方案**:
1. GitHub Actions 已配置 Docker Buildx
2. 如果持續失敗，可移除 `platforms` 參數只構建 `linux/amd64`

### 建置優化

- **快取**: 工作流程使用 GitHub Actions 快取減少建置時間
- **並行建置**: 多平台映像並行構建
- **增量建置**: Docker 層快取重用

## 🔐 安全性

### 漏洞掃描

工作流程包含 Trivy 安全掃描器:
- 自動掃描構建的映像
- 上傳結果到 GitHub Security 標籤
- 在 PR 中顯示安全報告

### 最佳實踐

1. **定期更新基礎映像**: 使用最新的 Python 基礎映像
2. **最小權限原則**: Docker Hub Token 只給予必要權限
3. **敏感資料保護**: 絕不在 Dockerfile 中包含機密資訊
4. **定期輪換**: 定期更新 Docker Hub Access Token

## 📊 監控指標

### 構建指標
- 構建時間
- 映像大小
- 成功/失敗率

### 使用指標
- 下載次數
- 使用的標籤分布
- 地理分布

## 🔄 更新流程

### 更新工作流程

1. 編輯 `.github/workflows/ai-agents-docker.yml`
2. 提交並推送變更
3. 工作流程將自動使用新配置

### 版本發布流程

1. **開發階段**: 推送到 feature 分支
2. **測試階段**: 建立 PR 到 main 分支
3. **發布階段**: 合併 PR 並建立版本標籤

```bash
# 發布新版本
git checkout main
git pull origin main
git tag v1.1.0
git push origin v1.1.0
```

## 🆘 支援

如遇問題，請參考:
- 📖 [GitHub Actions 文檔](https://docs.github.com/en/actions)
- 🐳 [Docker Hub 文檔](https://docs.docker.com/docker-hub/)
- 🔍 [Trivy 掃描器](https://github.com/aquasecurity/trivy)

---

**享受您的自動化 CI/CD 流程！** 🎉
