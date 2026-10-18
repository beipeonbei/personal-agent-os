# Day1-Execution-Pack（Day 1 落地执行包）

> 用途：把 Personal Agent OS V1 真正开始落地的执行手册。
> 节奏：**今天（Day 1）= Home Node 基础环境；明天（Day 2）= Office Node 基础环境。**
> Home Node 安装的详细耗时/排障见《Tonight-Install-Checklist.md》；本文给完整八部分结构与全部要素。
> 所有命令为 PowerShell；不含任何理论、趋势与远期规划。

---

## 第一部分 Home Node Day1 Checklist

按顺序执行：

### 1. 创建目录

```powershell
$root = "D:\Personal-Agent-OS"
New-Item -ItemType Directory -Force -Path `
  "$root\Vault", "$root\Projects", "$root\Agents", "$root\OpenHands", `
  "$root\Hermes", "$root\Harness", "$root\MCP", "$root\Config", `
  "$root\Prompts", "$root\Logs", "$root\Portal", "$root\Docs" | Out-Null
```

- [ ] 完成

### 2. 安装基础软件

顺序：Git → Docker Desktop → VS Code → Obsidian →（推荐）Cursor →（推荐）CodeBuddy。
逐项下载地址、验收命令见《Tonight-Install-Checklist.md》步骤 2。

- [ ] Git：`git --version` 有输出
- [ ] Docker Desktop：`docker info` 正常（自动带上 WSL2 后端）
- [ ] VS Code：`code --version` 有输出
- [ ] Obsidian：已安装
- [ ] Cursor（推荐）：已安装
- [ ] CodeBuddy（推荐）：已安装

### 3. 初始化同步

Vault 纳入 OneDrive：OneDrive 根目录建 `Vault`，用 junction 链到 `D:\Personal-Agent-OS\Vault`。完整命令与双向验收见《Tonight-Install-Checklist.md》步骤 3。

- [ ] 完成（D 盘路径与 OneDrive 路径双向可见）

### 4. 初始化 Git

```powershell
cd D:\Personal-Agent-OS
git init
git config user.name "beipeonbei"
git config user.email "1321386862@qq.com"
git branch -M main
```

- [ ] 完成（`git status` 正常且不含 `Logs/`）

### 5. 建立 Obsidian Vault

Obsidian 打开 `D:\Personal-Agent-OS\Vault` 作为 vault；确认六目录：`Inbox` `Projects` `Research` `AgentOS` `Startup` `Daily`；模板文件夹设为 `AgentOS/templates`（模板内容见第五部分）。

- [ ] 完成

### 6. 创建 GitHub Repo

网页建私有仓库 `personal-agent-os`（不初始化 README），然后：

```powershell
cd D:\Personal-Agent-OS
git add .
git commit -m "[home] init: Personal Agent OS v1 skeleton"
git remote add origin https://github.com/beipeonbei/personal-agent-os.git
git push -u origin main
```

- [ ] 完成（仓库网页可见文件）

### 7. 安装 OpenHands

Windows + Docker Desktop 方式，完整命令见第六部分。

- [ ] 完成（http://localhost:8000/canvas 可打开，冒烟测试通过）

---

## 第二部分 Office Node Day1 Checklist（明天执行）

### 1. 创建目录

与第一部分相同的 `New-Item` 命令，在 Office Node 上跑一遍（幂等）。

- [ ] 完成

### 2. 安装软件

顺序：Git → VS Code + GitHub Copilot → CodeBuddy → Obsidian → OpenHands →（推荐）Cursor →（按公司策略）Docker Desktop。
清单与下载地址见《Software-Inventory.md》。

- [ ] 完成

### 3. 配置同步

```powershell
cd D:\
git clone https://github.com/beipeonbei/personal-agent-os.git D:\Personal-Agent-OS
```

克隆后本地即有全部配置/文档/Agent 定义。Vault 同步：确认 OneDrive 已登录且 `OneDrive\Vault` 与 Home Node 同一账户（Vault 经 OneDrive 自动到位）。

- [ ] 完成（`git log` 能看到 Home Node 的提交）

### 4. 验证 Vault

1. 在 Office Node 的 Vault 新建一篇测试笔记（放 `Inbox/`）
2. 等 OneDrive 同步（通常 1 分钟内）
3. 在 Home Node 的 Obsidian 里确认能看到这篇笔记
4. 删除测试笔记

- [ ] 完成（双端可见）

### 5. 验证 GitHub

```powershell
cd D:\Personal-Agent-OS
git pull                 # 应无新变更或正常更新
git status               # 应干净
```

再改一个文件（如 `Config/office-node.yaml`）提交推送，回 Home Node `git pull` 确认可见。

- [ ] 完成（双向提交/pull 通）

---

## 第三部分 准确目录结构 + README 模板

```
D:\Personal-Agent-OS
├─ Vault          # Obsidian 知识库（OneDrive 同步）
├─ Projects       # 项目工作区（GitHub 管理，OpenHands 可访问）
├─ Agents         # Agent 定义（roles.yaml / agent-schema.md）
├─ OpenHands      # Agent 执行中心配置与任务工作区
├─ Hermes         # Phase 2 占位（未安装）
├─ Harness        # Phase 2 占位（未安装）
├─ MCP            # MCP 接入计划与配置
├─ Config         # 节点配置（office-node.yaml / home-node.yaml）
├─ Prompts        # Prompt 资产
├─ Logs           # 运行日志（本地，不同步）
├─ Portal         # Portal 源码预留（Phase 2）
└─ Docs           # 方案与执行文档
```

根目录另有 `README.md` 与 `.gitignore`。

**README 模板**（每个目录复制此结构填写）：

```markdown
# <目录名>

## 用途
<一句话说明这个目录放什么>

## 内容规则
- <规则 1>
- <规则 2>

## 同步归属
OneDrive / GitHub / 本地（三选一，按目录既定归属填）

## 状态
- [x] 已建立（YYYY-MM-DD）
```

---

## 第四部分 GitHub 初始化步骤

### 仓库命名

- 仓库名：`personal-agent-os`
- 可见性：**Private**（个人系统，不公开）
- 描述：Personal Agent OS — dual node config & docs

### .gitignore

以仓库骨架中的 `.gitignore` 为准，核心规则：

```
Logs/            # 日志永不入库
*.log
Config/local-*.yaml   # 本地敏感配置
.vscode/ .idea/       # 编辑器垃圾
Thumbs.db desktop.ini
Vault/.obsidian/workspace*.json   # Obsidian 本地状态
```

### 首次提交

```powershell
cd D:\Personal-Agent-OS
git add .
git commit -m "[home] init: Personal Agent OS v1 skeleton"
git remote add origin https://github.com/beipeonbei/personal-agent-os.git
git push -u origin main
```

### 目录规范（提交信息）

| 规则 | 说明 |
| --- | --- |
| 节点前缀 | `[home]` 或 `[office]` 开头，标明提交来自哪个节点 |
| 动作前缀 | `init:` / `add:` / `update:` / `fix:` / `docs:` |
| 示例 | `[home] update: roles.yaml 增加 Ops Agent 策略` |
| 禁止 | 无意义信息（如 "update"、"aaa"）；force push |

### 分支规范

| 规则 | 说明 |
| --- | --- |
| 主分支 | `main`，唯一长期分支 |
| 日常提交 | 小改动直接提交 `main`（个人私有仓库，不走重流程） |
| 结构性改动 | 可选开 `feature/<名称>` 分支，完成后合并回 `main` 并删除 |
| 同步纪律 | 每天开工先 `git pull`，收工 `git push` |

---

## 第五部分 Obsidian Vault 初始化

### 六目录结构

| 目录 | 用途 | 规则 |
| --- | --- | --- |
| `Inbox/` | 速记收集区 | 任何东西先扔这里，当天清空归类 |
| `Projects/` | 项目笔记 | 与 `D:\Personal-Agent-OS\Projects`（代码）对应，一文一项目 |
| `Research/` | 研究资料 | 问题、来源、结论三段式 |
| `AgentOS/` | Agent OS 运行笔记 | 模板、Agent 运行记录、踩坑复盘 |
| `Startup/` | 创业事务 | 创业相关事项与决策日志 |
| `Daily/` | 日记 | 一天一篇，命名 `YYYY-MM-DD` |

### 模板（放 `Vault/AgentOS/templates/`）

**Daily Note.md**：

```markdown
# {{date}}

## 今日任务
- [ ]

## 记录
（随手记，晚上归档到 Inbox/Research/Startup）

## 复盘
- 做完了什么：
- 卡在哪：
- 明天第一件事：
```

**Project.md**：

```markdown
# 项目：<名称>

- 状态：进行中 / 暂停 / 结束
- 代码位置：D:\Personal-Agent-OS\Projects\<名称>
- 目标：
- 本周动作：
- 相关链接：
```

**Research.md**：

```markdown
# 研究：<问题>

## 问题
<一句话>

## 来源
- <链接/文件，必须可溯源>

## 结论
<调研后的判断；没有结论就写"未结论 + 下一步">
```

**Startup Log.md**：

```markdown
# 创业日志 <日期>

## 事项
- 

## 决策
- <决策内容 + 理由 + 日期>

## 待办
- [ ]
```

### Obsidian 配置

设置 → 核心插件 → 开启"模板" → 模板文件夹路径：`AgentOS/templates`。

---

## 第六部分 OpenHands 安装步骤（Windows + Docker Desktop）

前提：Docker Desktop 已安装并启动。

```powershell
# 1. 拉取镜像（tag 以官方 README 当前版本为准；2026-10 官方为 1.27.1）
docker pull ghcr.io/openhands/agent-canvas:1.27.1

# 2. 准备工作目录（OpenHands 只能访问 /projects 下的项目）
$env:PROJECTS_PATH = "D:\Personal-Agent-OS\Projects"
New-Item -ItemType Directory -Force -Path $env:PROJECTS_PATH, "$env:USERPROFILE\.openhands" | Out-Null

# 3. 启动（端口只绑本机回环）
docker run -it --rm `
  -p 127.0.0.1:8000:8000 `
  -e AGENT_CANVAS_ALLOW_LAN_SESSION_KEY=true `
  -v "$($env:USERPROFILE)\.openhands:/home/openhands/.openhands" `
  -v "$($env:PROJECTS_PATH):/projects" `
  ghcr.io/openhands/agent-canvas:1.27.1
```

4. 浏览器打开 http://localhost:8000/canvas
5. 设置里添加模型（OpenAI 兼容接口：Base URL + API Key + 模型名）
6. 冒烟测试：让 Agent 在 `/projects` 下建 `hello.txt` 并读回

验收：界面可打开；一次对话任务成功。排障见《Tonight-Install-Checklist.md》排障表。

> 定位提醒：OpenHands 是 **Agent 执行中心**，不是日常入口；入口始终是 M365 Copilot。

---

## 第七部分 Day1 完成标准

以下五项全部满足，视为 Day1 成功：

- [ ] **Git 仓库建立**：`personal-agent-os` 已创建，本地首推成功，仓库网页可见文件
- [ ] **Vault 可同步**：OneDrive 侧与 `D:\Personal-Agent-OS\Vault` 双向可见；Vault 已纳入 Git
- [ ] **OpenHands 启动**：http://localhost:8000/canvas 可打开，冒烟测试通过
- [ ] **VS Code 工作正常**：`code --version` 有输出，能打开目录
- [ ] **Copilot 正常**：GitHub Copilot 扩展已登录，能补全

---

## 第八部分 Day2 计划（只到第 2 天）

Day2 = 在 **Office Node** 复刻基础环境，执行第二部分五步：

| 时间块 | 内容 |
| --- | --- |
| 上午 | 创建目录 + 安装软件（Git / VS Code + Copilot / CodeBuddy / Obsidian / OpenHands） |
| 下午 | 配置同步（clone 仓库 + OneDrive 登录） |
| 下班前 | 验证 Vault + 验证 GitHub + 两端对验（一端提交、另一端 pull 可见） |

Day2 完成标准：第二部分五个勾选框全部打勾；Home 与 Office 两端 `git log` 互相可见对方提交；一端建 Vault 笔记另一端可见。

不展开 90 天线与远期内容——那些等双节点基础环境稳定后再说。
