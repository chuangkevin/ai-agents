@echo off
setlocal enabledelayedexpansion

echo ====================================
echo 🚀 AI Agents 部署成功驗證工具
echo ====================================
echo.

set /p USERNAME="請輸入您的 Docker Hub 用戶名 (例如: kevin950805): "
if "!USERNAME!"=="" (
    echo ❌ 用戶名不能為空
    pause
    exit /b 1
)

echo.
echo 🔍 檢查部署狀態...
echo ────────────────────────────────

echo.
echo 📋 1. GitHub Actions 狀態檢查
echo    前往: https://github.com/chuangkevin/ai-agents/actions
echo    尋找最新的 "AI Agents Docker CI/CD" 工作流程
echo.
echo    ✅ 成功指標:
echo       - "Build and Push Docker Image" 步驟顯示綠色勾號
echo       - 看到 "Image Summary" 輸出
echo.
echo    ⚠️  可忽略的錯誤:
echo       - "Security Scan" 步驟的權限錯誤
echo       - "Resource not accessible by integration" 警告
echo.

echo 📋 2. Docker Hub 映像檢查
echo    前往: https://hub.docker.com/r/!USERNAME!/ai-agents
echo.
echo    ✅ 成功指標:
echo       - 看到 ai-agents repository
echo       - 有 "latest" 和其他標籤
echo       - 最後更新時間是最近的
echo.

echo 📋 3. 本地測試映像拉取
echo    執行以下命令測試:
echo.
echo    docker pull !USERNAME!/ai-agents:latest
echo.
if /i "%1"=="--test" (
    echo 🧪 正在執行測試...
    echo.
    echo 📥 嘗試拉取映像...
    docker pull !USERNAME!/ai-agents:latest
    if errorlevel 1 (
        echo ❌ 映像拉取失敗
        echo.
        echo 可能原因:
        echo 1. Docker Hub 上還沒有映像 - 檢查 GitHub Actions 是否成功
        echo 2. 映像名稱錯誤 - 確認用戶名是否正確
        echo 3. 映像是私有的 - 確認映像設定為公開
        echo.
    ) else (
        echo ✅ 映像拉取成功!
        echo.
        echo 🔍 映像資訊:
        docker images !USERNAME!/ai-agents:latest
        echo.
        echo 🎉 部署驗證成功!
    )
)

echo.
echo ====================================
echo 💡 提示:
echo.
echo 如果 GitHub Actions 中只有安全掃描失敗，
echo 但 Docker 映像構建成功，那麼部署就是成功的！
echo.
echo 主要關注點:
echo ✅ Docker 映像是否成功推送到 Docker Hub
echo ✅ 是否可以成功拉取映像
echo ✅ 應用程式是否可以正常運行
echo.
echo 執行完整測試請使用:
echo %~nx0 --test
echo ====================================
echo.
pause
