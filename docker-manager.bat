@echo off
setlocal enabledelayedexpansion

echo ====================================
echo 🛠️  AI Agents Docker 管理工具
echo ====================================
echo.

:menu
echo 請選擇操作:
echo.
echo 1. 🚀 啟動服務
echo 2. 🛑 停止服務
echo 3. 🔄 重啟服務
echo 4. 📊 查看狀態
echo 5. 📝 查看日誌
echo 6. 🧹 清理停止的容器
echo 7. 📥 拉取最新映像
echo 8. 🌐 開啟瀏覽器
echo 9. 🔧 編輯設定
echo 0. 🚪 退出
echo.

set /p choice="請輸入選項 (0-9): "

if "%choice%"=="1" goto start_service
if "%choice%"=="2" goto stop_service
if "%choice%"=="3" goto restart_service
if "%choice%"=="4" goto show_status
if "%choice%"=="5" goto show_logs
if "%choice%"=="6" goto cleanup
if "%choice%"=="7" goto pull_image
if "%choice%"=="8" goto open_browser
if "%choice%"=="9" goto edit_config
if "%choice%"=="0" goto exit

echo ❌ 無效選項，請重新選擇
goto menu

:start_service
echo.
echo 🚀 啟動 AI Agents 服務...
docker-compose up -d
if errorlevel 1 (
    echo ❌ 啟動失敗
) else (
    echo ✅ 服務已啟動
    echo 🌐 存取網址: http://localhost:5000
)
echo.
pause
goto menu

:stop_service
echo.
echo 🛑 停止 AI Agents 服務...
docker-compose down
echo ✅ 服務已停止
echo.
pause
goto menu

:restart_service
echo.
echo 🔄 重啟 AI Agents 服務...
docker-compose restart
echo ✅ 服務已重啟
echo.
pause
goto menu

:show_status
echo.
echo 📊 AI Agents 服務狀態:
echo ====================================
docker-compose ps
echo.
echo 🐳 Docker 系統資訊:
docker system df
echo.
pause
goto menu

:show_logs
echo.
echo 📝 AI Agents 服務日誌:
echo ====================================
echo 按 Ctrl+C 退出日誌檢視
echo.
docker-compose logs -f ai-agents
goto menu

:cleanup
echo.
echo 🧹 清理停止的容器和未使用的映像...
docker container prune -f
docker image prune -f
echo ✅ 清理完成
echo.
pause
goto menu

:pull_image
echo.
echo 📥 拉取最新的 AI Agents 映像...
docker pull kevin950805/ai-agents:latest
if errorlevel 1 (
    echo ❌ 拉取失敗
) else (
    echo ✅ 映像已更新
    echo 💡 提示: 使用選項 3 重啟服務以應用新映像
)
echo.
pause
goto menu

:open_browser
echo.
echo 🌐 開啟瀏覽器...
start http://localhost:5000
goto menu

:edit_config
echo.
echo 🔧 開啟設定檔案...
if exist ".env" (
    notepad .env
) else (
    echo ⚠️  .env 檔案不存在，從範本建立...
    copy ".env.example" ".env"
    notepad .env
)
goto menu

:exit
echo.
echo 👋 再見!
echo.
exit /b 0
