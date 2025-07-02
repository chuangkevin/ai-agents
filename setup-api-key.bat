@echo off
setlocal enabledelayedexpansion

echo ====================================
echo 🔑 OpenAI API 金鑰設定工具
echo ====================================
echo.

:: 檢查 .env 檔案
if not exist ".env" (
    echo 📝 .env 檔案不存在，從範本建立...
    if exist ".env.example" (
        copy ".env.example" ".env"
        echo ✅ 已建立 .env 檔案
    ) else (
        echo # AI Agents 環境變數設定 > .env
        echo OPENAI_API_KEY=your_openai_api_key_here >> .env
        echo DEBUG=False >> .env
        echo HOST=0.0.0.0 >> .env
        echo PORT=5000 >> .env
        echo ✅ 已建立基本 .env 檔案
    )
    echo.
)

:: 顯示目前的 API 金鑰狀態
echo 🔍 目前 OpenAI API 金鑰狀態:
findstr "OPENAI_API_KEY" .env
echo.

:: 檢查是否需要設定
findstr /C:"OPENAI_API_KEY=your_openai_api_key_here" .env >nul
if not errorlevel 1 (
    echo ⚠️  需要設定 OpenAI API 金鑰
    goto set_key
)

findstr /C:"OPENAI_API_KEY=$" .env >nul
if not errorlevel 1 (
    echo ⚠️  OpenAI API 金鑰為空
    goto set_key
)

echo ✅ OpenAI API 金鑰已設定
echo.
set /p CHANGE="是否要更改 API 金鑰? (y/N): "
if /i not "!CHANGE!"=="y" (
    goto done
)

:set_key
echo.
echo 🔑 請輸入您的 OpenAI API 金鑰:
echo.
echo 💡 提示:
echo    - API 金鑰通常以 'sk-' 開頭
echo    - 可在 https://platform.openai.com/api-keys 取得
echo    - 請確保帳戶有足夠的額度
echo.
set /p API_KEY="API Key: "

if "!API_KEY!"=="" (
    echo ❌ API 金鑰不能為空
    goto set_key
)

:: 簡單驗證格式
echo !API_KEY! | findstr /R "^sk-" >nul
if errorlevel 1 (
    echo ⚠️  警告: API 金鑰格式可能不正確 (通常以 sk- 開頭)
    set /p CONTINUE="是否繼續? (y/N): "
    if /i not "!CONTINUE!"=="y" (
        goto set_key
    )
)

:: 更新 .env 檔案
echo 💾 更新 .env 檔案...
powershell -Command "(Get-Content .env) -replace 'OPENAI_API_KEY=.*', 'OPENAI_API_KEY=!API_KEY!' | Set-Content .env"

echo ✅ API 金鑰已設定成功!
echo.

:done
echo 📋 完整的 .env 設定:
echo ====================================
type .env
echo ====================================
echo.

echo 🚀 接下來的步驟:
echo.
echo 1. 執行 start-docker-compose.bat 啟動服務
echo 2. 或執行 docker-manager.bat 進行管理
echo 3. 或直接執行: docker-compose up -d
echo.
echo 🌐 服務啟動後可存取: http://localhost:5000
echo.

set /p START="是否現在啟動服務? (Y/n): "
if /i not "!START!"=="n" (
    echo.
    echo 🚀 啟動服務...
    docker-compose up -d
    if not errorlevel 1 (
        echo ✅ 服務已啟動!
        echo 🌐 正在開啟瀏覽器...
        timeout /t 3 /nobreak >nul
        start http://localhost:5000
    )
)

echo.
pause
