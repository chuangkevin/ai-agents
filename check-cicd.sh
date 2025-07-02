#!/bin/bash

# GitHub Actions 工作流程狀態檢查腳本
# 用於檢查 Docker 構建是否成功

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函數：打印帶顏色的訊息
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 檢查 GitHub Actions 工作流程檔案
echo "🔍 檢查 GitHub Actions 工作流程設定..."
echo "============================================"

# 檢查工作流程目錄
if [ -d ".github/workflows" ]; then
    print_success "GitHub Actions 工作流程目錄存在"
else
    print_error "GitHub Actions 工作流程目錄不存在"
    exit 1
fi

# 檢查工作流程檔案
WORKFLOW_FILES=(".github/workflows/ai-agents-docker.yml" ".github/workflows/docker-build-push.yml")

for file in "${WORKFLOW_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "工作流程檔案存在: $file"
    else
        print_warning "工作流程檔案不存在: $file"
    fi
done

# 檢查 Dockerfile
echo ""
echo "🐳 檢查 Docker 設定..."
echo "========================"

if [ -f "Dockerfile" ]; then
    print_success "Dockerfile 存在"
else
    print_error "Dockerfile 不存在"
    exit 1
fi

if [ -f "docker-compose.yml" ]; then
    print_success "docker-compose.yml 存在"
else
    print_warning "docker-compose.yml 不存在"
fi

# 檢查環境變數檔案
echo ""
echo "⚙️  檢查環境設定..."
echo "===================="

if [ -f ".env.example" ]; then
    print_success ".env.example 存在"
else
    print_warning ".env.example 不存在"
fi

if [ -f ".env" ]; then
    print_warning ".env 存在 (請確認不要提交到 Git)"
else
    print_status ".env 不存在 (這是正常的)"
fi

# 檢查 .gitignore
if [ -f ".gitignore" ]; then
    if grep -q ".env" .gitignore; then
        print_success ".env 已被 .gitignore 忽略"
    else
        print_warning ".env 未被 .gitignore 忽略"
    fi
else
    print_warning ".gitignore 檔案不存在"
fi

# 檢查專案檔案
echo ""
echo "📁 檢查專案檔案..."
echo "=================="

REQUIRED_FILES=("app.py" "requirements.txt" "src/init_db.py")

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "必要檔案存在: $file"
    else
        print_error "必要檔案不存在: $file"
    fi
done

# 檢查 Git 設定
echo ""
echo "📋 GitHub Actions 設定提醒..."
echo "=============================="

print_status "請確認已在 GitHub 設定以下 Secrets:"
echo "   - DOCKER_USERNAME: 您的 Docker Hub 用戶名"
echo "   - DOCKER_PASSWORD: 您的 Docker Hub Access Token"
echo ""

print_status "工作流程將在以下情況觸發:"
echo "   - 推送到 main 分支"
echo "   - 建立版本標籤 (v*)"
echo "   - 手動觸發 (workflow_dispatch)"
echo ""

print_status "映像將推送到:"
echo "   - docker.io/\${DOCKER_USERNAME}/ai-agents:latest"
echo "   - docker.io/\${DOCKER_USERNAME}/ai-agents:<tag>"
echo ""

# 檢查是否在 Git 倉庫中
if [ -d ".git" ]; then
    print_success "Git 倉庫初始化完成"
    
    # 檢查遠端倉庫
    if git remote -v | grep -q "github.com"; then
        print_success "GitHub 遠端倉庫已設定"
    else
        print_warning "未檢測到 GitHub 遠端倉庫"
    fi
else
    print_warning "不在 Git 倉庫中"
fi

echo ""
echo "✅ 檢查完成！"
echo ""
print_status "下一步："
echo "1. 設定 GitHub Secrets (DOCKER_USERNAME, DOCKER_PASSWORD)"
echo "2. 推送代碼到 GitHub: git push origin main"
echo "3. 檢查 GitHub Actions 頁面查看建置狀態"
echo ""
print_success "準備就緒！GitHub Actions 將自動建置和推送 Docker 映像。"
