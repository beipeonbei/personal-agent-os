# Personal Agent OS（根目录）

> One Personal Agent OS / Two Nodes
> Office Node（公司电脑）+ Home Node（家里电脑）
> Shared Knowledge / Shared Config / Shared GitOps / Shared Memory
> 方案全文：`Docs/Dual-Node-Personal-Agent-OS-V1.md`

## 目录标准（两台电脑逐字一致）

| 目录 | 用途 | 同步通道 |
| --- | --- | --- |
| `Vault/` | Obsidian 知识库（Knowledge + Memory 权威源） | OneDrive + Git 双保险 |
| `Projects/` | 项目工作区 | GitHub |
| `Agents/` | Agent 定义（roles.yaml / agent-schema.md） | GitHub |
| `OpenHands/` | Agent 执行中心配置与任务工作区 | GitHub |
| `Hermes/` | Hermes 部署计划与配置（**未安装，未来从零部署**） | GitHub |
| `Harness/` | DeepSeek Harness 接口预留（**未安装，未来从零部署**） | GitHub |
| `MCP/` | MCP Server 统一配置与接入计划 | GitHub |
| `Config/` | 节点配置（office-node.yaml / home-node.yaml） | GitHub |
| `Prompts/` | Prompt 资产库 | GitHub |
| `Logs/` | 运行日志（本地产物） | **不同步** |
| `Portal/` | Personal Agent Portal 源码预留（未开发） | GitHub |
| `Docs/` | 方案文档 | GitHub |

## 双节点一致性规则

1. 两台电脑的目录树必须逐字一致；新增目录必须先改本文档与 `Docs/Dual-Node-Personal-Agent-OS-V1.md` 附录 A。
2. 组件差集仅允许：Home Node 多出 WSL2；Hermes 与 DeepSeek Harness 当前两节点均未安装，属未来阶段。
3. 日常入口唯一：M365 Copilot（Chief Agent）。OpenHands 是 Agent 执行中心，不是最终工作台。
4. 每天开工先 `git pull`，收工 `git push`；提交信息带节点前缀，如 `[office]` / `[home]`。
5. Vault 只放知识，仓库只放配置与代码；`Logs/` 永不入库。

## 当前状态（V1）

- 已就绪：目录标准、方案文档、Agent 定义、MCP 计划、Prompt 资产、Portal 规格
- 待安装：OpenHands（两节点）、Docker Desktop（Home 必装 / Office 推荐）、Cursor（推荐）
- 未来阶段：Hermes（Q2）、DeepSeek Harness（Q3）、Personal Agent Portal（Q4）
