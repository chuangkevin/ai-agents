@echo off
REM GitHub Actions 工作流程狀態檢查腳本 (Windows 版本)
REM 用於檢查 Docker 構建是否成功

setlocal enabledelayedexpansion

echo 🔍 檢查 GitHub Actions 工作流程設定...
echo ============================================

REM 檢查工作流程目錄
if exist ".github\workflows" (
    echo ✅ GitHub Actions 工作流程目錄存在
) else (
    echo ❌ GitHub Actions 工作流程目錄不存在
    exit /b 1
)

REM 檢查工作流程檔案
if exist ".github\workflows\ai-agents-docker.yml" (
    echo ✅ 工作流程檔案存在: ai-agents-docker.yml
) else (
    echo ⚠️  工作流程檔案不存在: ai-agents-docker.yml
)

if exist ".github\workflows\docker-build-push.yml" (
    echo ✅ 工作流程檔案存在: docker-build-push.yml
) else (
    echo ⚠️  工作流程檔案不存在: docker-build-push.yml
)

echo.
echo 🐳 檢查 Docker 設定...
echo ========================

if exist "Dockerfile" (
    echo ✅ Dockerfile 存在
) else (
    echo ❌ Dockerfile 不存在
    exit /b 1
)

if exist "docker-compose.yml" (
    echo ✅ docker-compose.yml 存在
) else (
    echo ⚠️  docker-compose.yml 不存在
)

echo.
echo ⚙️  檢查環境設定...
echo ====================

if exist ".env.example" (
    echo ✅ .env.example 存在
) else (
    echo ⚠️  .env.example 不存在
)

if exist ".env" (
    echo ⚠️  .env 存在 (請確認不要提交到 Git)
) else (
    echo ℹ️  .env 不存在 (這是正常的)
)

if exist ".gitignore" (
    findstr /C:".env" .gitignore >nul
    if !errorlevel! equ 0 (
        echo ✅ .env 已被 .gitignore 忽略
    ) else (
        echo ⚠️  .env 未被 .gitignore 忽略
    )
) else (
    echo ⚠️  .gitignore 檔案不存在
)

echo.
echo 📁 檢查專案檔案...
echo ==================

if exist "app.py" (
    echo ✅ 必要檔案存在: app.py
) else (
    echo ❌ 必要檔案不存在: app.py
)

if exist "requirements.txt" (
    echo ✅ 必要檔案存在: requirements.txt
) else (
    echo ❌ 必要檔案不存在: requirements.txt
)

if exist "src\init_db.py" (
    echo ✅ 必要檔案存在: src\init_db.py
) else (
    echo ❌ 必要檔案不存在: src\init_db.py
)

echo.
echo 📋 GitHub Actions 設定提醒...
echo ==============================

echo ℹ️  請確認已在 GitHub 設定以下 Secrets:
echo    - DOCKER_USERNAME: 您的 Docker Hub 用戶名
echo    - DOCKER_PASSWORD: 您的 Docker Hub Access Token
echo.

echo ℹ️  工作流程將在以下情況觸發:
echo    - 推送到 main 分支
echo    - 建立版本標籤 (v*)
echo    - 手動觸發 (workflow_dispatch)
echo.

echo ℹ️  映像將推送到:
echo    - docker.io/^${DOCKER_USERNAME}/ai-agents:latest
echo    - docker.io/^${DOCKER_USERNAME}/ai-agents:^<tag^>
echo.

REM 檢查是否在 Git 倉庫中
if exist ".git" (
    echo ✅ Git 倉庫初始化完成
    
    REM 檢查遠端倉庫
    git remote -v | findstr "github.com" >nul
    if !errorlevel! equ 0 (
        echo ✅ GitHub 遠端倉庫已設定
    ) else (
        echo ⚠️  未檢測到 GitHub 遠端倉庫
    )
) else (
    echo ⚠️  不在 Git 倉庫中
)

echo.
echo ✅ 檢查完成！
echo.
echo ℹ️  下一步：
echo 1. 設定 GitHub Secrets (DOCKER_USERNAME, DOCKER_PASSWORD)
echo 2. 推送代碼到 GitHub: git push origin main
echo 3. 檢查 GitHub Actions 頁面查看建置狀態
echo.
echo ✅ 準備就緒！GitHub Actions 將自動建置和推送 Docker 映像。

pause
