@echo off
setlocal enabledelayedexpansion

echo ====================================
echo 📊 AI Agents 部署狀態總覽
echo ====================================
echo.

echo 🔍 1. 本地檔案檢查
echo ────────────────────
if exist "app.py" (echo ✅ app.py) else (echo ❌ app.py)
if exist "requirements.txt" (echo ✅ requirements.txt) else (echo ❌ requirements.txt)
if exist "Dockerfile" (echo ✅ Dockerfile) else (echo ❌ Dockerfile)
if exist "docker-compose.yml" (echo ✅ docker-compose.yml) else (echo ❌ docker-compose.yml)
if exist ".github\workflows\ai-agents-docker.yml" (echo ✅ GitHub Actions 工作流程) else (echo ❌ GitHub Actions 工作流程)
if exist ".env.example" (echo ✅ .env.example) else (echo ❌ .env.example)
echo.

echo 🐳 2. Docker 環境檢查
echo ────────────────────
docker --version > nul 2>&1
if errorlevel 1 (
    echo ❌ Docker 未安裝或未運行
) else (
    echo ✅ Docker 已安裝
    docker info > nul 2>&1
    if errorlevel 1 (
        echo ⚠️  Docker 未運行
    ) else (
        echo ✅ Docker 服務運行中
    )
)
echo.

echo 📂 3. Git 狀態檢查
echo ────────────────────
git status --porcelain > nul 2>&1
if errorlevel 1 (
    echo ❌ 不是 Git 專案
) else (
    echo ✅ Git 專案已初始化
    git remote -v | findstr origin > nul 2>&1
    if errorlevel 1 (
        echo ❌ 未設定 GitHub 遠端
    ) else (
        echo ✅ GitHub 遠端已設定
        for /f "tokens=*" %%i in ('git status --porcelain') do set CHANGES=%%i
        if defined CHANGES (
            echo ⚠️  有未提交的變更
        ) else (
            echo ✅ 所有變更已提交
        )
    )
)
echo.

echo 🔑 4. 環境變數檢查
echo ────────────────────
if exist ".env" (
    echo ✅ .env 檔案存在
    findstr "OPENAI_API_KEY" .env > nul 2>&1
    if errorlevel 1 (
        echo ❌ .env 中未找到 OPENAI_API_KEY
    ) else (
        echo ✅ OPENAI_API_KEY 已設定
    )
) else (
    echo ⚠️  .env 檔案不存在 (首次運行需要建立)
)
echo.

echo 📋 5. 接下來的步驟
echo ────────────────────
echo 🔸 GitHub Secrets 設定:
echo    - 前往 GitHub 專案設定添加 DOCKER_USERNAME 和 DOCKER_PASSWORD
echo    - 參考 CICD_GUIDE.md 詳細說明
echo.
echo 🔸 本地測試:
echo    - 運行: python test_and_start.py (本地測試)
echo    - 運行: docker-compose up (Docker 測試)
echo.
echo 🔸 部署測試:
echo    - 推送代碼觸發 GitHub Actions
echo    - 檢查 Docker Hub 映像
echo    - 運行: test-docker-image.bat (映像測試)
echo.
echo ====================================
echo 💡 詳細文檔: QUICKSTART.md, DOCKER_GUIDE.md, CICD_GUIDE.md
echo ====================================
pause
