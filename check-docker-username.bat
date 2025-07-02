@echo off
echo ====================================
echo 🔍 Docker Hub 用戶名檢查工具
echo ====================================
echo.
echo 請檢查您的 Docker Hub 用戶名：
echo.
echo 1. 前往：https://hub.docker.com/
echo 2. 登入後，點擊右上角的用戶頭像
echo 3. 在下拉選單中會顯示您的用戶名
echo.
echo 或者：
echo 1. 前往：https://hub.docker.com/settings/general
echo 2. 查看 "Docker ID" 欄位
echo.
echo ⚠️  重要：
echo - 用戶名通常不是 email 格式
echo - 如果您的 email 是 kevin950805@gmail.com
echo - 您的 Docker ID 可能是 kevin950805 或其他格式
echo.
echo 找到正確的 Docker ID 後，請：
echo 1. 在 GitHub Secrets 中設定 DOCKER_USERNAME = 您的Docker ID
echo 2. 在 GitHub Secrets 中設定 DOCKER_PASSWORD = 您的Access Token
echo.
echo ====================================
pause
