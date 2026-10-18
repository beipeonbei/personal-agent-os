# Software-Inventory（双节点软件清单）

> 用途：Home Node 与 Office Node 分别需要装什么、装什么顺序、去哪下。
> 安装顺序原则：Git → Docker → 编辑器/IDE → 知识库 → Agent 工具。地基先装，工具后装。
> Phase 1 范围（本周）：OpenHands + Obsidian + VS Code + CodeBuddy + GitHub Copilot + M365 Copilot。Hermes 与 DeepSeek Harness 为 Phase 2，本周不装。

## Home Node（家里电脑）

| # | 软件 | 用途 | 是否必须 | 下载地址 | 安装顺序 |
| --- | --- | --- | --- | --- | --- |
| 1 | Git | 版本控制，GitOps 同步前提 | 必须 | https://git-scm.com/download/win | 第 1 个装 |
| 2 | Docker Desktop | OpenHands 沙箱运行底座（含 WSL2 后端） | 必须 | https://www.docker.com/products/docker-desktop/ | 第 2 个装（装完重启） |
| 3 | WSL2 | Docker Desktop 的 Linux 后端 | 必须（随 Docker 启用） | https://learn.microsoft.com/windows/wsl/install | 随 Docker Desktop 一并启用 |
| 4 | VS Code | 统一编码入口 | 必须 | https://code.visualstudio.com/ | 第 3 个装 |
| 5 | GitHub Copilot | 编码补全与辅助（VS Code 扩展） | 必须 | https://marketplace.visualstudio.com/items?itemName=GitHub.copilot | VS Code 装后立即装扩展 |
| 6 | Obsidian | 知识库 / Memory 本地视图 | 必须 | https://obsidian.md/download | 第 4 个装 |
| 7 | OpenHands | Agent 执行中心（Docker 方式运行） | 必须 | https://github.com/OpenHands/OpenHands | 最后装（依赖 Docker） |
| 8 | Cursor | 第二种编码界面（AI IDE） | 推荐 | https://cursor.com/download | VS Code 之后 |
| 9 | CodeBuddy | 代码 Agent | 推荐 | https://www.codebuddy.ai/ | 任意时间 |
| 10 | M365 Copilot | Chief Agent / 唯一日常入口 | 网页/企业环境 | 公司 Microsoft 365 门户 | 无需安装 |

## Office Node（公司电脑）

| # | 软件 | 用途 | 是否必须 | 下载地址 | 安装顺序 |
| --- | --- | --- | --- | --- | --- |
| 1 | Git | 版本控制，clone/push 前提 | 必须 | https://git-scm.com/download/win | 第 1 个装 |
| 2 | VS Code | 统一编码入口 | 必须 | https://code.visualstudio.com/ | 第 2 个装 |
| 3 | GitHub Copilot | 编码补全与辅助（VS Code 扩展） | 必须 | https://marketplace.visualstudio.com/items?itemName=GitHub.copilot | VS Code 装后立即装扩展 |
| 4 | CodeBuddy | 代码 Agent | 必须 | https://www.codebuddy.ai/ | 第 3 个装 |
| 5 | Obsidian | 知识库本地视图（Vault 经 OneDrive 到位） | 必须 | https://obsidian.md/download | 第 4 个装 |
| 6 | OpenHands | Agent 执行中心 | 必须 | https://github.com/OpenHands/OpenHands | 最后装（Home 端验证过再装） |
| 7 | Docker Desktop | OpenHands 沙箱底座 | 推荐（公司策略允许再装） | https://www.docker.com/products/docker-desktop/ | OpenHands 之前 |
| 8 | Cursor | 第二种编码界面 | 推荐（可选） | https://cursor.com/download | 任意时间 |
| 9 | M365 Copilot | Chief Agent / 唯一日常入口 | 必须（环境既有） | 公司 Microsoft 365 门户 | 无需安装 |

## 两节点差异速查

| 维度 | Home Node | Office Node |
| --- | --- | --- |
| WSL2 | 必须（随 Docker） | 不装 |
| Docker Desktop | 必须 | 推荐（看公司策略） |
| Cursor | 推荐 | 推荐（可选） |
| CodeBuddy | 推荐 | 必须 |
| Hermes / DeepSeek Harness | Phase 2，不装 | Phase 2，不装 |

## 重点软件说明

- **VS Code**：统一编码入口，GitHub Copilot / CodeBuddy 都挂在它上面；安装时勾选 Add to PATH。
- **Git**：没有 Git 就没有配置同步；安装后必须配 user.name / user.email（见执行包第四部分）。
- **Docker Desktop**：OpenHands 的唯一下埋；Home Node 必装，装完重启，等 "Docker Desktop is running" 再继续。
- **WSL2**：Docker Desktop 默认后端；`wsl --install` 一条命令，Home Node 专属。
- **Obsidian**：知识库入口；Vault 路径固定 `D:\Personal-Agent-OS\Vault`，两节点一致。
- **Cursor**：备用编码界面，按需启用，不强制。
- **CodeBuddy**：代码 Agent；Office 必装、Home 推荐。
- **GitHub Copilot**：VS Code 扩展，装完需登录 GitHub 账号。
- **OpenHands**：Docker 方式运行（`ghcr.io/openhands/agent-canvas`），端口 8000，只访问 `/projects` 目录。

## 网页即用（无需安装）

| 工具 | 用途 | 地址 |
| --- | --- | --- |
| Google AI Studio | Prompt 实验、模型比较 | https://aistudio.google.com |
| GitHub | 仓库管理（网页操作建仓） | https://github.com |

## 附录：本期不安装的组件

| 组件 | 状态 | 说明 |
| --- | --- | --- |
| Claude Code | 环境不可用 | 不列入任何实施步骤；环境允许后再评估 |
| OpenAI Codex | 环境不可用 | 同上 |
| Grok | 环境不可用 | 同上 |
| Hermes | Phase 2 | 双节点基础环境稳定后再从零部署 |
| DeepSeek Harness | Phase 2 | 同上 |
