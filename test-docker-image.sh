#!/bin/bash

# Docker 映像測試腳本
# 用於測試從 Docker Hub 拉取的映像是否正常運行

set -e

# 設定變數
DOCKER_USERNAME=${1:-"your-username"}
IMAGE_NAME="ai-agents"
CONTAINER_NAME="ai-agents-test"
PORT=8001

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

cleanup() {
    print_status "清理測試環境..."
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
}

# 設定清理陷阱
trap cleanup EXIT

echo "🧪 Docker 映像測試"
echo "=================="
echo "Docker 用戶名: $DOCKER_USERNAME"
echo "映像名稱: $IMAGE_NAME"
echo "測試端口: $PORT"
echo ""

# 檢查環境變數檔案
if [ ! -f ".env" ]; then
    print_warning ".env 檔案不存在，建立測試用環境變數檔案"
    cp .env.example .env.test
    echo "OPENAI_API_KEY=test-key-for-docker-test" >> .env.test
    ENV_FILE=".env.test"
else
    ENV_FILE=".env"
fi

# 拉取最新映像
print_status "拉取 Docker 映像..."
if docker pull $DOCKER_USERNAME/$IMAGE_NAME:latest; then
    print_success "映像拉取成功"
else
    print_error "映像拉取失敗"
    exit 1
fi

# 運行容器
print_status "啟動測試容器..."
if docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:8000 \
    --env-file $ENV_FILE \
    $DOCKER_USERNAME/$IMAGE_NAME:latest; then
    print_success "容器啟動成功"
else
    print_error "容器啟動失敗"
    exit 1
fi

# 等待服務啟動
print_status "等待服務啟動..."
sleep 10

# 檢查容器狀態
if docker ps | grep -q $CONTAINER_NAME; then
    print_success "容器運行正常"
else
    print_error "容器未正常運行"
    print_status "容器日誌:"
    docker logs $CONTAINER_NAME
    exit 1
fi

# 測試健康檢查端點
print_status "測試健康檢查端點..."
max_retries=5
retry_count=0

while [ $retry_count -lt $max_retries ]; do
    if curl -s -f http://localhost:$PORT/api/health > /dev/null; then
        print_success "健康檢查通過"
        response=$(curl -s http://localhost:$PORT/api/health)
        echo "回應: $response"
        break
    else
        retry_count=$((retry_count + 1))
        print_warning "健康檢查失敗，重試 $retry_count/$max_retries"
        sleep 5
    fi
done

if [ $retry_count -eq $max_retries ]; then
    print_error "健康檢查最終失敗"
    print_status "容器日誌:"
    docker logs $CONTAINER_NAME
    exit 1
fi

# 測試首頁
print_status "測試首頁..."
if curl -s -f http://localhost:$PORT/ > /dev/null; then
    print_success "首頁回應正常"
else
    print_warning "首頁回應異常"
fi

# 顯示容器資訊
print_status "容器資訊:"
docker ps --filter name=$CONTAINER_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 顯示映像資訊
print_status "映像資訊:"
docker images $DOCKER_USERNAME/$IMAGE_NAME --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

print_success "測試完成！"
print_status "容器正在 http://localhost:$PORT 運行"
print_status "使用 'docker stop $CONTAINER_NAME' 停止測試容器"

# 清理測試環境變數檔案
if [ -f ".env.test" ]; then
    rm .env.test
fi
