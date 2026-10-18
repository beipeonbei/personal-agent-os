# Agents — Agent 定义资产

本目录是 **Agent Config Sync** 的物理载体，对应方案第三部分 3.4。

## 文件

| 文件 | 说明 |
| --- | --- |
| `roles.yaml` | 五角色定义：Chief / Research / Coding / Browser / Ops |
| `agent-schema.md` | Agent 定义规范（字段、全局 Policy、变更纪律） |
| `README.md` | 本说明 |

## 规则

1. 当前在岗仅 Chief（M365 Copilot）；Research / Coding / Browser / Ops 为定义预留，等待 DeepSeek Harness（Q3）上线后逐步激活。
2. 任何修改必须提交 GitHub 仓库；对端 `git pull` 后生效，本地未提交视为无效。
3. `entry: true` 全表唯一——单一入口原则的机器可执行形式。
4. 新 Agent 的工具若引用 MCP，必须先在 `../MCP/mcp-plan.md` 登记。
