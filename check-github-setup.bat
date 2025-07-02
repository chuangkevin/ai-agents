@echo off
echo ====================================
echo 🔍 GitHub Actions CI/CD 設定檢查
echo ====================================
echo.

echo 📂 檢查 GitHub Actions 工作流程:
if exist ".github\workflows\ai-agents-docker.yml" (
    echo ✅ GitHub Actions 工作流程已設定
) else (
    echo ❌ GitHub Actions 工作流程未找到
)

echo.
echo 📋 接下來需要完成的步驟:
echo.
echo 1. 🔑 在 GitHub 專案設定 Secrets:
echo    - 前往: https://github.com/您的用戶名/ai-agents/settings/secrets/actions
echo    - 新增 DOCKER_USERNAME (您的 Docker Hub 用戶名)
echo    - 新增 DOCKER_PASSWORD (您的 Docker Hub Access Token)
echo.
echo 2. 🐳 Docker Hub Access Token 建立:
echo    - 前往: https://hub.docker.com/settings/security
echo    - 點擊 "New Access Token"
echo    - 名稱填入: ai-agents-github-actions
echo    - 權限選擇: Read, Write, Delete
echo    - 複製產生的 Token 並貼到 GitHub Secrets 的 DOCKER_PASSWORD
echo.
echo 3. 🚀 觸發第一次自動部署:
echo    - 推送任何變更到 main 分支
echo    - 或在 GitHub Actions 頁面手動觸發工作流程
echo.
echo 4. 📊 查看部署狀態:
echo    - GitHub Actions: https://github.com/您的用戶名/ai-agents/actions
echo    - Docker Hub: https://hub.docker.com/r/您的用戶名/ai-agents
echo.
echo 5. 🏷️ 添加狀態徽章 (可選):
echo    - 參考 BADGES.md 檔案說明
echo    - 將徽章代碼加入 README.md
echo.
echo ====================================
echo 💡 提示: 記得將 "您的用戶名" 替換為實際的 GitHub/Docker Hub 用戶名
echo ====================================
pause
