@echo off
echo ====================================
echo 🚀 AI Agents Docker Compose 啟動器
echo ====================================
echo.

:: 檢查 .env 檔案是否存在
if not exist ".env" (
    echo ⚠️  .env 檔案不存在，正在從範本建立...
    copy ".env.example" ".env"
    echo.
    echo ✅ 已建立 .env 檔案
    echo.
    echo 🔑 請編輯 .env 檔案並設定您的 OpenAI API 金鑰:
    echo    OPENAI_API_KEY=您的實際API金鑰
    echo.
    echo 編輯完成後請重新執行此腳本
    echo.
    pause
    exit /b 1
)

:: 檢查 OPENAI_API_KEY 是否設定
findstr /C:"OPENAI_API_KEY=your_openai_api_key_here" .env >nul
if not errorlevel 1 (
    echo ❌ 請在 .env 檔案中設定您的實際 OpenAI API 金鑰
    echo.
    echo 目前設定: OPENAI_API_KEY=your_openai_api_key_here
    echo 需要改為: OPENAI_API_KEY=sk-...您的實際金鑰
    echo.
    notepad .env
    pause
    exit /b 1
)

echo 🔍 檢查 Docker 狀態...
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker 未運行，請先啟動 Docker Desktop
    pause
    exit /b 1
)
echo ✅ Docker 運行中

echo.
echo 🐳 檢查 Docker Hub 映像...
set /p CONFIRM="是否要拉取最新的映像? (y/N): "
if /i "!CONFIRM!"=="y" (
    echo 📥 拉取最新映像...
    docker pull kevin950805/ai-agents:latest
    if errorlevel 1 (
        echo ❌ 映像拉取失敗，請檢查:
        echo    1. 網路連接
        echo    2. Docker Hub 映像是否存在
        echo    3. 映像名稱是否正確
        pause
        exit /b 1
    )
    echo ✅ 映像拉取成功
)

echo.
echo 🚀 啟動 AI Agents 服務...
docker-compose up -d

if errorlevel 1 (
    echo ❌ 服務啟動失敗
    echo.
    echo 查看詳細錯誤:
    echo docker-compose logs ai-agents
    pause
    exit /b 1
)

echo ✅ 服務啟動成功!
echo.
echo 📊 服務資訊:
docker-compose ps

echo.
echo 🌐 存取資訊:
echo    網址: http://localhost:5000
echo    健康檢查: http://localhost:5000/
echo.
echo 📋 常用命令:
echo    查看日誌: docker-compose logs -f ai-agents
echo    停止服務: docker-compose down
echo    重啟服務: docker-compose restart
echo.

set /p OPEN="是否要開啟瀏覽器? (Y/n): "
if /i not "!OPEN!"=="n" (
    start http://localhost:5000
)

echo.
echo ====================================
echo 🎉 AI Agents 已成功啟動!
echo ====================================
pause
