@echo off
setlocal enabledelayedexpansion

echo ====================================
echo 🔧 Docker Compose 環境初始化
echo ====================================
echo.

:: 設定路徑變數
set "COMPOSE_DIR=%~dp0"
cd /d "%COMPOSE_DIR%"

echo 📂 當前目錄: %CD%
echo.

:: 建立必要的目錄
echo 📁 建立必要目錄...
if not exist "data" mkdir data
if not exist "logs" mkdir logs
if not exist "app-data" mkdir app-data

echo ✅ 目錄建立完成
echo.

:: 檢查 .env 檔案
if not exist ".env" (
    echo 📝 建立 .env 檔案...
    echo # AI Agents 環境變數設定 > .env
    echo OPENAI_API_KEY=your_openai_api_key_here >> .env
    echo DEBUG=False >> .env
    echo HOST=0.0.0.0 >> .env
    echo PORT=5000 >> .env
    echo SECRET_KEY=your_secret_key_here >> .env
    echo ✅ 已建立 .env 檔案
    echo.
    echo ⚠️  請編輯 .env 檔案並設定您的 OpenAI API 金鑰
    notepad .env
    pause
)

:: 檢查 Docker
echo 🐳 檢查 Docker 狀態...
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker 未運行，請先啟動 Docker Desktop
    pause
    exit /b 1
)
echo ✅ Docker 運行中

:: 清理可能存在的容器
echo 🧹 清理舊容器...
docker container stop ai-agents-app >nul 2>&1
docker container rm ai-agents-app >nul 2>&1
docker volume rm ai-agents_ai-agents-data >nul 2>&1

echo.
echo 🎯 選擇 Docker Compose 版本:
echo.
echo 1. 🛡️  使用 Docker 卷 (推薦) - 資料完全由 Docker 管理
echo 2. 📁 使用目錄掛載 - 資料存在本地目錄
echo.
set /p VERSION="請選擇版本 (1/2): "

if "%VERSION%"=="2" (
    echo.
    echo 📁 使用目錄掛載版本...
    copy docker-compose-alt.yml docker-compose.yml >nul 2>&1
    echo ✅ 已切換到目錄掛載版本
) else (
    echo.
    echo 🛡️  使用 Docker 卷版本 (預設)...
    echo ✅ 使用原始配置
)

echo.
echo 🚀 啟動服務...
docker-compose pull
docker-compose up -d

if errorlevel 1 (
    echo ❌ 啟動失敗
    echo.
    echo 📋 查看錯誤訊息:
    docker-compose logs
    pause
    exit /b 1
)

echo ✅ 服務啟動成功!
echo.
echo 📊 服務狀態:
docker-compose ps
echo.
echo 🌐 存取網址: http://localhost:5000
echo.
echo ⏳ 等待服務完全啟動...
timeout /t 10 /nobreak >nul

set /p OPEN="是否開啟瀏覽器? (Y/n): "
if /i not "%OPEN%"=="n" (
    start http://localhost:5000
)

echo.
echo ====================================
echo 🎉 初始化完成!
echo ====================================
echo.
echo 📋 管理命令:
echo    查看狀態: docker-compose ps
echo    查看日誌: docker-compose logs -f
echo    停止服務: docker-compose down
echo    重啟服務: docker-compose restart
echo.
pause
