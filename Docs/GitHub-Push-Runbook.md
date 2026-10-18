# GitHub-Push-Runbook（推送 + Docker + OpenHands 执行手册）

> 适用：Home Node。前置状态：本地 git 已初始化、已有首次提交、origin 已配、GitHub 仓库已创建。
> 仓库：https://github.com/beipeonbei/personal-agent-os
> 本手册三块：**GitHub Push → Docker 验证 → OpenHands 启动**。

---

## 一、检查 origin

```powershell
git -C D:\Personal-Agent-OS remote -v
```

成功结果示例：

```text
origin  https://github.com/beipeonbei/personal-agent-os.git (fetch)
origin  https://github.com/beipeonbei/personal-agent-os.git (push)
```

失败结果示例与处理：

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| 无任何输出 | remote 未配置 | `git -C D:\Personal-Agent-OS remote add origin https://github.com/beipeonbei/personal-agent-os.git` |
| 地址错误（用户名/仓库名不对） | 配错 | `git -C D:\Personal-Agent-OS remote set-url origin https://github.com/beipeonbei/personal-agent-os.git` |

- [ ] `origin` 指向 https://github.com/beipeonbei/personal-agent-os.git

---

## 二、首次推送

```powershell
git -C D:\Personal-Agent-OS push -u origin main
```

成功结果示例（2026-10-18 实测输出）：

```text
To https://github.com/beipeonbei/personal-agent-os.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

> 注意：PowerShell 可能把 git 的进度输出包成红色"错误"显示，只要看到 `[new branch] main -> main` 就是成功，不用管。

失败结果示例与处理：

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| `remote: Repository not found.` | 仓库没建或地址错 | 去 github.com 建私有仓库 `personal-agent-os`；核对 `git remote -v` |
| `Permission denied` / 403 | 认证失败 | 浏览器弹窗登录 GitHub；或换 PAT：`git remote set-url origin https://<token>@github.com/beipeonbei/personal-agent-os.git` |
| `fetch first` / non-fast-forward | 远端有你没有的提交 | `git -C D:\Personal-Agent-OS pull --rebase origin main` 后再推；**禁止 force push** |
| `Support for password authentication was removed` | 用了密码而非 token | 换 Personal Access Token（github.com → Settings → Developer settings → Tokens） |

- [ ] 看到 `[new branch] main -> main`

---

## 三、推送验收

```powershell
git -C D:\Personal-Agent-OS log --oneline
git -C D:\Personal-Agent-OS status -sb
git -C D:\Personal-Agent-OS ls-remote origin
```

成功标准（三项同时满足）：

1. `git log --oneline` 有提交 `8873e73 init personal-agent-os`
2. `git status -sb` 显示 `## main...origin/main`（无 ahead/behind）
3. `git ls-remote origin` 的 `refs/heads/main` 哈希与本地提交哈希一致

2026-10-18 实测结果（已通过）：

```text
8873e73 init personal-agent-os
## main...origin/main
8873e73a075f6a5b4847250c34236aa8d7a86cc8        refs/heads/main
```

- [ ] 三项验收全过 = **GitHub 项完成**

---

## 四、Docker 验证

前提：Docker Desktop 已安装、已重启、托盘显示 running。

```powershell
docker version
docker run hello-world
```

成功：`docker version` 有 Server 段版本号；hello-world 打印 `Hello from Docker!`。
失败排查见 `Home-Node-Completion-Runbook.md` 第 1 部分（5 类失败全覆盖）。

- [ ] Docker 正常

---

## 五、OpenHands 启动

前提：第四节 Docker 验证已通过。

```powershell
# 1. 拉镜像
docker pull ghcr.io/openhands/agent-canvas:1.27.1

# 2. 准备目录
$env:PROJECTS_PATH = "D:\Personal-Agent-OS\Projects"
New-Item -ItemType Directory -Force -Path $env:PROJECTS_PATH, "$env:USERPROFILE\.openhands" | Out-Null

# 3. 启动
docker run -it --rm `
  -p 127.0.0.1:8000:8000 `
  -e AGENT_CANVAS_ALLOW_LAN_SESSION_KEY=true `
  -v "$($env:USERPROFILE)\.openhands:/home/openhands/.openhands" `
  -v "$($env:PROJECTS_PATH):/projects" `
  ghcr.io/openhands/agent-canvas:1.27.1

# 4. 浏览器访问
start http://localhost:8000/canvas
```

模型配置：界面 Settings → LLM → 填 Base URL + API Key + Model 名（用现有可用 key）。
冒烟测试：让 Agent 在 `/projects` 建 `hello.txt` 并读回。

验收：

- [ ] http://localhost:8000/canvas 正常打开
- [ ] 模型配置后有回复
- [ ] `D:\Personal-Agent-OS\Projects\hello.txt` 被创建

OpenHands 排障见 `Home-Node-Completion-Runbook.md` 第 8 部分。

---

## 六、三项总验收

```text
□ GitHub 正常    （第四节三项全过）
□ Docker 正常    （docker version 有 Server 段）
□ OpenHands 正常 （localhost:8000/canvas 可开 + 冒烟测试通过）
```

全勾 = Home Node 全部完成。之后所有变更按此节奏提交：

```powershell
cd D:\Personal-Agent-OS
git add .
git commit -m "[home] 说明改了什么"
git push
```
