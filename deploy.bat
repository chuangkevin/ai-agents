@echo off
chcp 65001 >nul

echo 🚀 開始部署 AI Agents 服務...

REM 檢查 Docker 是否安裝
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker 未安裝，請先安裝 Docker Desktop
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose 未安裝，請先安裝 Docker Compose
    pause
    exit /b 1
)

REM 檢查 .env 檔案
if not exist ".env" (
    echo ❌ .env 檔案不存在，請先建立並設定 OPENAI_API_KEY
    pause
    exit /b 1
)

findstr /C:"OPENAI_API_KEY=sk-" .env >nul
if %errorlevel% neq 0 (
    echo ❌ 請在 .env 檔案中設定有效的 OPENAI_API_KEY
    pause
    exit /b 1
)

echo ✅ 環境檢查通過

REM 停止現有服務
echo 🛑 停止現有服務...
docker-compose down

REM 建構映像
echo 🔨 建構 Docker 映像...
docker-compose build

REM 啟動服務
echo 🚀 啟動服務...
docker-compose up -d

REM 等待服務啟動
echo ⏳ 等待服務啟動...
timeout /t 10 /nobreak >nul

REM 健康檢查
echo 🔍 檢查服務狀態...
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:8000/api/health' -UseBasicParsing | Out-Null; exit 0 } catch { exit 1 }"
if %errorlevel% equ 0 (
    echo ✅ 服務部署成功！
    echo 🌐 服務地址: http://localhost:8000
    echo 📊 服務狀態: docker-compose ps
    echo 📋 服務日誌: docker-compose logs -f
    echo.
    echo 按任意鍵開啟瀏覽器訪問服務...
    pause >nul
    start http://localhost:8000
) else (
    echo ❌ 服務啟動失敗，請檢查日誌：
    echo docker-compose logs
    pause
)
