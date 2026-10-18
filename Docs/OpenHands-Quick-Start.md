# OpenHands Quick Start（一页版）

> 前提：Docker Desktop 已装、已重启、托盘显示 running。
> 全部命令在 PowerShell 执行。访问地址：http://localhost:8000/canvas

## 1. 安装（拉镜像）

```powershell
docker pull ghcr.io/openhands/agent-canvas:1.27.1
```

拉取失败提示 not found → 去 https://github.com/OpenHands/OpenHands README 换当前 tag。

## 2. 启动

```powershell
$env:PROJECTS_PATH = "D:\Personal-Agent-OS\Projects"
New-Item -ItemType Directory -Force -Path $env:PROJECTS_PATH, "$env:USERPROFILE\.openhands" | Out-Null

docker run -it --rm `
  -p 127.0.0.1:8000:8000 `
  -e AGENT_CANVAS_ALLOW_LAN_SESSION_KEY=true `
  -v "$($env:USERPROFILE)\.openhands:/home/openhands/.openhands" `
  -v "$($env:PROJECTS_PATH):/projects" `
  ghcr.io/openhands/agent-canvas:1.27.1
```

- 停止：运行窗口按 `Ctrl+C`
- 常驻：把 `-it --rm` 换成 `-d --restart unless-stopped`
- 端口占用改 `-p 127.0.0.1:8001:8000`，访问地址相应改 8001

## 3. 模型配置

1. 浏览器打开 http://localhost:8000/canvas
2. Settings → LLM / Model
3. 填三项：Base URL（模型服务地址）、API Key（你的 key）、Model（模型名）
4. 保存后发一条测试消息，有回复 = 成功

## 4. 验证

```powershell
docker ps
start http://localhost:8000/canvas
```

冒烟测试：让 Agent 在 `/projects` 下创建 `hello.txt` 并读回内容。

- [ ] 页面正常打开
- [ ] 模型有回复
- [ ] `D:\Personal-Agent-OS\Projects\hello.txt` 被创建
