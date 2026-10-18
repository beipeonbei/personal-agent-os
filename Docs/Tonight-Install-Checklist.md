# Tonight-Install-Checklist（今晚安装清单 · Home Node）

> 适用范围：**Home Node（家里电脑）**，今晚按顺序一次性执行完。
> 总预计耗时：**约 3–4 小时**（含软件下载；网络快可压到 2.5 小时）
> 使用方式：按步骤往下做，每步都有「命令 + 验收标准」；出问题先查本文末尾《失败排查表》。
> Office Node（公司电脑）明天再执行，不要今晚混着做。
> 所有命令在 **PowerShell** 中运行；若某台电脑上目录/文件已预先建好，命令均为幂等（`-Force`），可安全重跑。

## 时间总览

| 步骤 | 内容 | 预计耗时 |
| --- | --- | --- |
| 0 | 开机前检查 | 5 分钟 |
| 1 | 创建目录结构 | 10 分钟 |
| 2 | 安装基础软件 | 60–90 分钟 |
| 3 | 初始化同步（OneDrive + Vault） | 15 分钟 |
| 4 | 初始化 Git | 10 分钟 |
| 5 | 建立 Obsidian Vault | 15 分钟 |
| 6 | 创建 GitHub 仓库并首推 | 20 分钟 |
| 7 | 安装 OpenHands（Docker） | 30–40 分钟 |
| 8 | 当日收尾验收 | 10 分钟 |

---

## 步骤 0：开机前检查（5 分钟）

- [ ] 确认 OneDrive 已登录（任务栏有蓝色云朵图标；没有先登录）
- [ ] 确认 D 盘可用空间 ≥ 20GB（Docker 镜像 + 项目用）
- [ ] 确认你有 GitHub 账号 beipeonbei 的登录状态（浏览器已登录即可）

验收：以下命令有输出（OneDrive 目录存在）：

```powershell
Test-Path "$env:USERPROFILE\OneDrive"
```

> 若你的 OneDrive 不在默认路径，先找到真实路径，后面步骤 3 里替换 `$env:USERPROFILE\OneDrive`。

---

## 步骤 1：创建目录结构（10 分钟）

```powershell
$root = "D:\Personal-Agent-OS"
New-Item -ItemType Directory -Force -Path `
  "$root\Vault", "$root\Projects", "$root\Agents", "$root\OpenHands", `
  "$root\Hermes", "$root\Harness", "$root\MCP", "$root\Config", `
  "$root\Prompts", "$root\Logs", "$root\Portal", "$root\Docs" | Out-Null
```

验收：`Get-ChildItem $root` 列出 12 个目录（11 个 + Docs）。

---

## 步骤 2：安装基础软件（60–90 分钟）

按此顺序装，不要跳序（Git 和 Docker 是后面步骤的地基）。

### 2.1 Git（必装，10 分钟）

- 下载：https://git-scm.com/download/win
- 安装：一路默认选项下一步（默认编辑器选 VS Code 亦可，后面可改）
- 验收：

```powershell
git --version
```

### 2.2 Docker Desktop（必装，20–30 分钟，含重启）

- 下载：https://www.docker.com/products/docker-desktop/
- 安装完成后**重启电脑**（WSL2 组件需要）
- 启动 Docker Desktop，等托盘图标显示 "Docker Desktop is running"
- 验收：

```powershell
docker --version
docker info
```

> Docker Desktop 默认使用 WSL2 后端；若安装中提示启用 WSL，按提示启用并重启。Home Node 必须装 Docker（OpenHands 沙箱依赖）。

### 2.3 VS Code + GitHub Copilot（必装，15 分钟）

- 下载：https://code.visualstudio.com/
- 安装时勾选 "Add to PATH"（否则 `code` 命令不可用）
- 打开 VS Code → 扩展市场搜索 **GitHub Copilot** → 安装 → 左下角账户图标登录 GitHub
- 验收：

```powershell
code --version
```

VS Code 里 Copilot 面板可用、能补全即正常。

### 2.4 Obsidian（必装，5 分钟）

- 下载：https://obsidian.md/download
- 安装后先不开 vault（步骤 5 统一建）

### 2.5 Cursor（推荐，10 分钟）

- 下载：https://cursor.com/download
- 安装并登录；作为 VS Code 之外的第二种编码界面，按需启用

### 2.6 CodeBuddy（推荐，10 分钟）

- 官网：https://www.codebuddy.ai/ ，按官网当前指引安装（IDE 插件 / CLI）

---

## 步骤 3：初始化同步（OneDrive + Vault，15 分钟）

目标：`D:\Personal-Agent-OS\Vault` 成为 OneDrive 同步目录的入口（真实文件在 OneDrive 里，用 junction 链接，D 盘路径不变）。

```powershell
# 1. 确保 D 盘目标目录存在且为空
New-Item -ItemType Directory -Force -Path "D:\Personal-Agent-OS\Vault" | Out-Null

# 2. 在 OneDrive 根目录建同名目录（真实存放位置）
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\OneDrive\Vault" | Out-Null

# 3. 删除 D 盘占位目录，建 junction（需要管理员权限的 PowerShell）
Remove-Item "D:\Personal-Agent-OS\Vault"
cmd /c mklink /J "D:\Personal-Agent-OS\Vault" "$env:USERPROFILE\OneDrive\Vault"
```

验收（双向可见）：

```powershell
# 在 OneDrive 侧建测试文件
New-Item -ItemType File -Path "$env:USERPROFILE\OneDrive\Vault\_sync_test.txt" | Out-Null
# D 盘路径应能读到
Test-Path "D:\Personal-Agent-OS\Vault\_sync_test.txt"   # 期望 True
# 清理
Remove-Item "D:\Personal-Agent-OS\Vault\_sync_test.txt"
```

> 备选：若不想用 junction，可把 Vault 直接留在 D 盘、只走 Git 同步（见步骤 4）；但 OneDrive 同步摩擦更低，推荐上面的做法。

---

## 步骤 4：初始化 Git（10 分钟）

```powershell
cd D:\Personal-Agent-OS
git init
git config user.name "beipeonbei"
git config user.email "1321386862@qq.com"
git branch -M main
```

若 `.gitignore` 不存在，创建它（内容如下）：

```powershell
@"
# 本地产物，永不入库
Logs/
*.log
*.log.*

# 本地敏感配置
Config/local-*.yaml

# 编辑器与系统垃圾
.vscode/
.idea/
Thumbs.db
desktop.ini
`$RECYCLE.BIN/

# Vault 工作区文件（Obsidian 本地状态，非知识内容）
Vault/.obsidian/workspace.json
Vault/.obsidian/workspace-mobile.json
"@ | Set-Content -Path "D:\Personal-Agent-OS\.gitignore" -Encoding UTF8
```

验收：`git status` 能看到 untracked 文件列表，且列表中**没有** `Logs/`。

---

## 步骤 5：建立 Obsidian Vault（15 分钟）

1. 打开 Obsidian → "Open folder as vault" → 选择 `D:\Personal-Agent-OS\Vault`
2. 确认六个目录已在（骨架可能已预建）：`Inbox` `Projects` `Research` `AgentOS` `Startup` `Daily`；缺哪个就在 vault 里新建
3. 开启模板功能：设置 → 核心插件 → 打开"模板" → 模板文件夹路径填 `AgentOS/templates`
4. 从 `AgentOS/templates/` 插入一篇 Daily Note 试一下

验收：Obsidian 左侧文件树可见六个目录；新建日记能套用模板。

---

## 步骤 6：创建 GitHub 仓库并首推（20 分钟）

**网页操作**（github.com，已登录状态）：

1. 右上角 "+" → New repository
2. Repository name 填 `personal-agent-os`
3. 选 **Private**
4. **不要**勾选 "Add a README"（本地已有内容，避免冲突）
5. Create repository

**本地命令**：

```powershell
cd D:\Personal-Agent-OS
git add .
git commit -m "[home] init: Personal Agent OS v1 skeleton"
git remote add origin https://github.com/beipeonbei/personal-agent-os.git
git push -u origin main
```

验收：刷新仓库网页能看到文件；`git log --oneline` 有 1 条提交记录。

---

## 步骤 7：安装 OpenHands（30–40 分钟）

前提：Docker Desktop 已启动（步骤 2.2 验收通过）。

```powershell
# 1. 拉取镜像（tag 以官方 README 当前版本为准；2026-10 官方为 1.27.1）
docker pull ghcr.io/openhands/agent-canvas:1.27.1

# 2. 准备工作目录（OpenHands 只能访问 /projects 下的项目）
$env:PROJECTS_PATH = "D:\Personal-Agent-OS\Projects"
New-Item -ItemType Directory -Force -Path $env:PROJECTS_PATH, "$env:USERPROFILE\.openhands" | Out-Null

# 3. 启动（端口只绑本机回环，会话密钥自动注入）
docker run -it --rm `
  -p 127.0.0.1:8000:8000 `
  -e AGENT_CANVAS_ALLOW_LAN_SESSION_KEY=true `
  -v "$($env:USERPROFILE)\.openhands:/home/openhands/.openhands" `
  -v "$($env:PROJECTS_PATH):/projects" `
  ghcr.io/openhands/agent-canvas:1.27.1
```

4. 浏览器打开 **http://localhost:8000/canvas**
5. 首次使用：在设置里添加模型（OpenAI 兼容接口：Base URL + API Key + 模型名），用你现有的任何可用 key
6. 冒烟测试：让 Agent 在 `/projects` 下创建 `hello.txt` 并读回内容

验收：浏览器能打开 Canvas 界面；一次对话任务成功执行。

> 常用变体：
> - 停止容器：焦点在运行窗口按 `Ctrl+C`
> - 想常驻后台：把 `-it --rm` 换成 `-d --restart unless-stopped`，日志用 `docker logs -f <容器名>` 看
> - 端口冲突：把 `-p 127.0.0.1:8000:8000` 改成 `-p 127.0.0.1:8001:8000`，改用 http://localhost:8001/canvas 访问

---

## 步骤 8：当日收尾验收（10 分钟）

- [ ] Git 仓库建立且 `git push` 成功（仓库网页可见文件）
- [ ] Vault 可同步（OneDrive 侧与 D 盘路径双向可见；且已随 Git 提交）
- [ ] OpenHands 启动（http://localhost:8000/canvas 可打开）
- [ ] VS Code + GitHub Copilot 工作正常（能补全）
- [ ] CodeBuddy 可工作

全部打勾 = Home Node Day1 完成。收工命令：

```powershell
cd D:\Personal-Agent-OS
git add .
git commit -m "[home] day1 done"
git push
```

---

## 失败排查表

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| `docker: error during connect` | Docker Desktop 未启动 | 启动 Docker Desktop，等托盘图标稳定后再跑命令 |
| 安装 Docker 提示缺 WSL2 | 系统未启用 WSL | 管理员 PowerShell 跑 `wsl --install`，重启；或在 Docker Desktop 设置里勾选 WSL2 后端 |
| 端口 8000 被占用 | 其他服务占了 8000 | `netstat -ano \| findstr :8000` 找到 PID 结束它，或改绑 8001（见步骤 7 变体） |
| `git push` 报 403 / 认证失败 | 未登录 GitHub | 浏览器弹窗登录；或换 Personal Access Token：`git remote set-url origin https://<token>@github.com/beipeonbei/personal-agent-os.git` |
| `mklink` 报无权限 | PowerShell 非管理员 | 用管理员权限重开 PowerShell 再跑步骤 3 |
| OneDrive 出现冲突副本 | 双端同时编辑同一文件 | 当天合并回主文件并删除副本（规则见主方案 3.5） |
| OpenHands 页面打不开 | 容器没起来或端口错 | `docker ps` 看容器状态；看运行窗口的日志输出 |
| Copilot 扩展不生效 | 未登录 GitHub | VS Code 左下角账户图标登录 |
| `code` 命令找不到 | 安装时没勾 Add to PATH | 重装 VS Code 勾选该项，或手动加安装目录到 PATH |
