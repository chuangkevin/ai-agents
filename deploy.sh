#!/bin/bash

# AI Agents 部署腳本

echo "🚀 開始部署 AI Agents 服務..."

# 檢查 Docker 是否安裝
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安裝，請先安裝 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安裝，請先安裝 Docker Compose"
    exit 1
fi

# 檢查 .env 檔案
if [ ! -f ".env" ]; then
    echo "❌ .env 檔案不存在，請先建立並設定 OPENAI_API_KEY"
    exit 1
fi

# 檢查 OPENAI_API_KEY
if ! grep -q "OPENAI_API_KEY=sk-" .env; then
    echo "❌ 請在 .env 檔案中設定有效的 OPENAI_API_KEY"
    exit 1
fi

echo "✅ 環境檢查通過"

# 停止現有服務
echo "🛑 停止現有服務..."
docker-compose down

# 建構映像
echo "🔨 建構 Docker 映像..."
docker-compose build

# 啟動服務
echo "🚀 啟動服務..."
docker-compose up -d

# 等待服務啟動
echo "⏳ 等待服務啟動..."
sleep 10

# 健康檢查
echo "🔍 檢查服務狀態..."
if curl -f http://localhost:8000/api/health > /dev/null 2>&1; then
    echo "✅ 服務部署成功！"
    echo "🌐 服務地址: http://localhost:8000"
    echo "📊 服務狀態: docker-compose ps"
    echo "📋 服務日誌: docker-compose logs -f"
else
    echo "❌ 服務啟動失敗，請檢查日誌："
    echo "docker-compose logs"
fi
