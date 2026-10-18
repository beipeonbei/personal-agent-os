# Home-Node-Completion-Runbook（Home Node 今晚收尾手册）

> 当前进度：约 60%（Git / VS Code / Cursor / Obsidian / CodeBuddy / 目录已就绪）
> 剩余：Docker Desktop → Git Init → GitHub Repo → Obsidian 配置 → OneDrive 同步 → OpenHands
> 使用方式：按部分顺序往下做；每部分有命令、验收、排障。所有命令在 PowerShell 里跑。

---

## 第 1 部分 Docker 验证

前提：Docker Desktop 已安装并重启过电脑。

### 验证命令

```powershell
docker version
docker run hello-world
```

### 成功结果示例

`docker version` 输出分两段：Client 和 **Server** 都有版本号（Server 段有输出 = 守护进程在跑）。

```text
Client:
 Version:           27.x.x
 ...

Server: Docker Engine
 Engine:
  Version:          27.x.x
```

`docker run hello-world` 最后打印：

```text
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### 失败结果示例与处理

| 失败现象 | 原因 | 处理 |
| --- | --- | --- |
| `docker : 无法将"docker"项识别为 cmdlet…` | Docker Desktop 未装或未加入 PATH | 装 Docker Desktop 后**重启电脑**；重开 PowerShell 再试 |
| `error during connect: ... pipe\docker_engine` | Docker Desktop 没启动 | 启动 Docker Desktop，等托盘图标显示 running 再跑 |
| `docker version` 只有 Client 段、无 Server 段 | 守护进程未就绪 | 等 30 秒重试；不行就退出 Docker Desktop 重进 |
| WSL2 相关报错 | WSL 未启用 | 管理员 PowerShell 跑 `wsl --install`，重启；或 Docker Desktop 设置里确认 WSL2 后端已勾选 |
| hello-world 拉取超时 | 网络慢 | 重试；或先 `docker pull hello-world` 再 run |

- [ ] `docker version` Server 段有版本号
- [ ] `docker run hello-world` 打印 Hello from Docker!

---

## 第 2 部分 Git 初始化

### 完整命令

```powershell
cd D:\Personal-Agent-OS
git init
git config user.name "beipeonbei"
git config user.email "1321386862@qq.com"
git branch -M main
```

### 验收命令

```powershell
git status
```

### 成功结果示例

```text
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        Agents/
        Config/
        Docs/
        ...
```

看到 `On branch main` + 一堆 Untracked 文件 = 成功。列表里**不应**出现 `Logs/`（已被 .gitignore 排除）。

- [ ] `git status` 显示 On branch main

---

## 第 3 部分 GitHub 初始化

### 仓库名称

`personal-agent-os`（私有）

### 私有仓库创建步骤（网页操作）

1. 浏览器登录 https://github.com （账号 beipeonbei）
2. 右上角 **+** → **New repository**
3. Repository name 填 `personal-agent-os`
4. 选 **Private**
5. **不要**勾选 "Add a README file"（本地已有内容，避免冲突）
6. 点 **Create repository**

### 首次推送命令

```powershell
cd D:\Personal-Agent-OS
git add .
git commit -m "[home] init: Personal Agent OS v1 skeleton"
git remote add origin https://github.com/beipeonbei/personal-agent-os.git
git push -u origin main
```

推送时浏览器会弹 GitHub 登录窗，授权即可。

### 验收标准

- [ ] 刷新仓库网页，能看到 `.gitignore`、`Vault`、`Docs` 等文件
- [ ] 本地 `git log --oneline` 有 1 条提交
- [ ] 本地 `git remote -v` 显示 origin 指向 personal-agent-os.git

---

## 第 4 部分 Obsidian 配置

### Vault 设置步骤

1. 打开 Obsidian → 左下角 **Open folder as vault**（或 Open another vault）
2. 选择 `D:\Personal-Agent-OS\Vault` → 点 **打开**
3. 信任该文件夹（Trust author and enable plugins）

### 模板目录设置

1. 左下角齿轮 **Settings** → **Core plugins** → 打开 **Templates**
2. **Templates** 设置里，Template folder location 填：`AgentOS/templates`
3. 四个模板应可见：`Daily Note.md`、`Project.md`、`Research.md`、`Startup Log.md`

### Daily Note 设置

1. Settings → Core plugins → 打开 **Daily notes**
2. New file location 填：`Daily`
3. Template file location 填：`AgentOS/templates/Daily Note.md`
4. 左侧栏日历图标 → 点今天 → 自动生成 `Daily/2026-10-18.md` 并套用模板

### 截图检查项（打开后应看到）

- [ ] 左侧文件树根目录有六个文件夹：`Inbox` `Projects` `Research` `AgentOS` `Startup` `Daily`
- [ ] 点开 `AgentOS/templates` 能看到 4 个模板文件
- [ ] 日历面板存在，点今天能新建一篇带"今日任务/记录/复盘"三段的日记
- [ ] Settings → Templates 里模板路径显示 `AgentOS/templates`（不是默认的空白）

---

## 第 5 部分 OneDrive 配置

### 第一步：检测 OneDrive

```powershell
Test-Path "$env:OneDrive"
```

### 情况 A：返回 True（OneDrive 已登录）

执行同步配置（junction 链接，让 D 盘路径与 OneDrive 双向可见）：

```powershell
# 1. OneDrive 侧建真实目录
New-Item -ItemType Directory -Force -Path "$env:OneDrive\Vault" | Out-Null

# 2. 删除 D 盘占位目录，建 junction（用管理员权限 PowerShell）
Remove-Item "D:\Personal-Agent-OS\Vault"
cmd /c mklink /J "D:\Personal-Agent-OS\Vault" "$env:OneDrive\Vault"
```

验收：

```powershell
New-Item -ItemType File -Path "$env:OneDrive\Vault\_t.txt" | Out-Null
Test-Path "D:\Personal-Agent-OS\Vault\_t.txt"    # 期望 True
Remove-Item "D:\Personal-Agent-OS\Vault\_t.txt"
```

- [ ] True（D 盘能读到 OneDrive 侧新建的文件）

> 注意：junction 建好后，Obsidian 里打开的 Vault 路径不变，仍是 `D:\Personal-Agent-OS\Vault`，无需重新配置。

### 情况 B：返回 False（OneDrive 未登录）

1. 开始菜单搜索 **OneDrive** → 打开 → 用微软账号登录
2. 登录后确认同步文件夹位置（默认 `C:\Users\Administrator\OneDrive`）
3. 登录完成后回到"情况 A"执行 junction 配置

- [ ] `Test-Path "$env:OneDrive"` 变为 True，并完成情况 A

---

## 第 6 部分 OpenHands 安装（Windows + Docker Desktop）

前提：第 1 部分 Docker 验证已通过。

### 1. 拉取镜像

```powershell
docker pull ghcr.io/openhands/agent-canvas:1.27.1
```

> tag `1.27.1` 为 2026-10-17 官方 README 版本；如拉取失败提示 not found，去 https://github.com/OpenHands/OpenHands 的 README 看当前 tag 替换。

### 2. 启动

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

### 3. 浏览器访问

打开 **http://localhost:8000/canvas**

### 4. 模型配置

1. 界面里进 Settings（设置）→ LLM / Model 配置
2. 添加一个 OpenAI 兼容接口：
   - Base URL：你的模型服务地址
   - API Key：你的 key
   - Model：模型名
3. 保存后发一条测试消息，有回复 = 配置成功

> 用你现有的任何可用 key；本机没有预设值，不指定具体服务商。

### 5. 冒烟测试

让 Agent 执行：在 `/projects` 下创建 `hello.txt`，内容写一行字，然后读回。

### 验收

- [ ] **http://localhost:8000/canvas 正常打开**（能看到界面，不是连接失败）
- [ ] 模型配置后有回复
- [ ] 冒烟测试通过（`D:\Personal-Agent-OS\Projects\hello.txt` 被创建）

---

## 第 7 部分 最终验收（Phase 1 完成检查表）

全部打勾 = Home Node 今晚完成。

```text
□ Docker 正常      （docker version 有 Server 段；hello-world 通过）
□ Git 正常         （git status 显示 On branch main）
□ GitHub 正常      （仓库网页可见文件；push 成功）
□ Obsidian 正常    （Vault 打开；六目录可见；Daily Note 可新建）
□ OneDrive 正常    （Test-Path D 盘 junction 返回 True）
□ OpenHands 正常   （http://localhost:8000/canvas 打开；冒烟测试通过）
□ VS Code 正常     （code --version 有输出；能打开 D:\Personal-Agent-OS）
□ CodeBuddy 正常   （codebuddy 命令可执行）
```

收尾提交（全勾后执行）：

```powershell
cd D:\Personal-Agent-OS
git add .
git commit -m "[home] day1 done: docker/github/vault/openhands ready"
git push
```

---

## 第 8 部分 阻塞处理（故障排查表）

### Docker 失败

| 现象 | 处理 |
| --- | --- |
| `docker` 命令不存在 | 装 Docker Desktop → **重启电脑** → 重开 PowerShell |
| `error during connect` 管道错误 | 启动 Docker Desktop，等托盘 running 再试 |
| 只有 Client 无 Server | 等 30 秒；不行退出 Docker Desktop 重进 |
| WSL2 报错 | 管理员 PowerShell：`wsl --install` → 重启 |
| hello-world 拉取超时 | `docker pull hello-world` 单独拉一次再 run |

### OpenHands 失败

| 现象 | 处理 |
| --- | --- |
| `docker pull` 报 not found | 去官方 README 换当前 tag：https://github.com/OpenHands/OpenHands |
| 页面打不开（连接失败） | `docker ps` 看容器在不在；看运行窗口日志；端口被占就改 `-p 127.0.0.1:8001:8000` 用 8001 访问 |
| 页面打开但模型无回复 | 回第 6 部分第 4 步检查 Base URL / Key / Model 名；换一个可用 key 试 |
| 容器起来就退出 | 看日志报错；多为卷路径不存在——确认 `D:\Personal-Agent-OS\Projects` 和 `$env:USERPROFILE\.openhands` 已建 |
| 冒烟测试找不到文件 | 确认访问的是 `/projects`（= `D:\Personal-Agent-OS\Projects`），不是容器内其他路径 |

### Git 推送失败

| 现象 | 处理 |
| --- | --- |
| `git push` 403 / 认证失败 | 浏览器弹窗登录 GitHub；或换 Personal Access Token：`git remote set-url origin https://<token>@github.com/beipeonbei/personal-agent-os.git` |
| `remote origin already exists` | `git remote set-url origin https://github.com/beipeonbei/personal-agent-os.git` |
| push 被拒（non-fast-forward） | `git pull --rebase` 后再 push；**禁止 force push** |
| 提交带出了 `Logs/` | 检查根目录 `.gitignore` 是否存在且含 `Logs/`；`git rm -r --cached Logs` 后重新提交 |

### OneDrive 失败

| 现象 | 处理 |
| --- | --- |
| `Test-Path "$env:OneDrive"` 为 False | 开始菜单开 OneDrive 登录微软账号，完成后重跑检测 |
| `mklink` 报无权限 | 用**管理员权限** PowerShell 重跑 junction 命令 |
| junction 建了但 Obsidian 里 vault 为空 | 确认 Obsidian 打开的是 `D:\Personal-Agent-OS\Vault`；OneDrive 侧文件需等同步完成 |
| 出现冲突副本 | 当天合并回主文件并删除副本，不堆积 |
| OneDrive 不同步 | 看任务栏云图标状态；暂停/恢复同步；确认登录的是同一微软账号 |

---

以上全部完成 = Home Node 基础环境搭建完成（Docker / Git / GitHub / Obsidian / OneDrive / OpenHands 六项就绪），明天开始 Office Node 同步部署。

