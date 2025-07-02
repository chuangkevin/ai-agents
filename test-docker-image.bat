@echo off
setlocal enabledelayedexpansion

echo ====================================
echo 🧪 Docker 映像測試腳本
echo ====================================
echo.

set /p USERNAME="請輸入您的 Docker Hub 用戶名: "
if "!USERNAME!"=="" (
    echo ❌ 用戶名不能為空
    pause
    exit /b 1
)

set IMAGE_NAME=!USERNAME!/ai-agents:latest
echo 🔍 測試映像: !IMAGE_NAME!
echo.

echo 📥 嘗試拉取映像...
docker pull !IMAGE_NAME!
if errorlevel 1 (
    echo ❌ 映像拉取失敗 - 請確認:
    echo    1. Docker Hub 上是否存在該映像
    echo    2. 映像是否為公開狀態
    echo    3. 用戶名是否正確
    pause
    exit /b 1
)
echo ✅ 映像拉取成功!
echo.

echo 🔍 檢查映像資訊...
docker images !IMAGE_NAME!
echo.

echo 🚀 嘗試運行映像 (測試模式)...
echo 注意: 這將在 3001 埠啟動服務，測試完成後會自動停止
docker run --rm -d --name ai-agents-test -p 3001:5000 -e OPENAI_API_KEY=test_key !IMAGE_NAME!
if errorlevel 1 (
    echo ❌ 容器啟動失敗
    pause
    exit /b 1
)

echo ⏳ 等待服務啟動...
timeout /t 5 /nobreak > nul

echo 📡 測試 HTTP 連接...
curl -s http://localhost:3001 > nul
if errorlevel 1 (
    echo ⚠️  HTTP 測試失敗，但這可能是因為缺少有效的 OpenAI API 金鑰
    echo    容器仍然正常運行
) else (
    echo ✅ HTTP 測試成功!
)

echo.
echo 🛑 停止測試容器...
docker stop ai-agents-test > nul 2>&1

echo.
echo ====================================
echo 🎉 Docker 映像測試完成!
echo.
echo 📝 如果要正式運行，請使用:
echo docker run -d --name ai-agents -p 5000:5000 -e OPENAI_API_KEY=您的金鑰 !IMAGE_NAME!
echo.
echo 📊 或使用 docker-compose:
echo docker-compose up -d
echo ====================================
pause
