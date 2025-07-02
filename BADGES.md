# GitHub Actions Status Badges

您可以在 README.md 中加入以下狀態徽章來顯示 CI/CD 狀態：

## Docker Build Status

```markdown
[![Docker Build](https://github.com/your-username/ai-agents/actions/workflows/ai-agents-docker.yml/badge.svg)](https://github.com/your-username/ai-agents/actions/workflows/ai-agents-docker.yml)
```

## Docker Hub

```markdown
[![Docker Hub](https://img.shields.io/docker/pulls/your-username/ai-agents)](https://hub.docker.com/r/your-username/ai-agents)
[![Docker Image Size](https://img.shields.io/docker/image-size/your-username/ai-agents/latest)](https://hub.docker.com/r/your-username/ai-agents)
```

## 完整範例

將以下內容加入您的 README.md 檔案頂部：

```markdown
# 多領域AI Agent系統

[![Docker Build](https://github.com/your-username/ai-agents/actions/workflows/ai-agents-docker.yml/badge.svg)](https://github.com/your-username/ai-agents/actions/workflows/ai-agents-docker.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/your-username/ai-agents)](https://hub.docker.com/r/your-username/ai-agents)
[![Docker Image Size](https://img.shields.io/docker/image-size/your-username/ai-agents/latest)](https://hub.docker.com/r/your-username/ai-agents)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

智能問答平台，能夠自動識別用戶問題的領域並派發給對應的專家Agent...
```

記得將 `your-username` 替換為您的實際 GitHub 和 Docker Hub 用戶名 (例如: `chuangkevin`)。

## 📱 狀態徽章說明

- **Docker Build**: 顯示 GitHub Actions 構建狀態
- **Docker Hub**: 顯示映像下載次數  
- **Docker Image Size**: 顯示映像大小
- **License**: 顯示專案授權
