# Agent Schema 规范

`roles.yaml` 中每个 Agent 定义必须符合本规范。Schema 是 Agent Config Sync 的契约：一端改 Schema，两端同时生效，杜绝"家里一套、公司一套"。

## 字段定义

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `id` | string | 是 | 唯一标识，小写连字符 |
| `name` | string | 是 | 显示名 |
| `role` | enum | 是 | `chief` / `research` / `coding` / `browser` / `ops` |
| `status` | enum | 是 | `active`（在岗）/ `reserved`（定义预留） |
| `host` | string | 是 | 承载组件（`m365-copilot` / `openhands` / `hermes` / `tbd`） |
| `entry` | bool | 否 | 是否唯一日常入口，全表最多一个 `true` |
| `responsibilities` | list | 是 | 职责清单，至少一条 |
| `tools` | list | 是 | 可用工具；引用的 MCP 必须在 `../MCP/mcp-plan.md` 中有登记 |
| `policy` | map | 否 | 该 Agent 的私有策略 |

## 全局 Policy 字段（跨 Agent 强制）

| 字段 | 值 | 说明 |
| --- | --- | --- |
| `single_entry` | true | 日常入口唯一（Chief）；其他 Agent 不得成为并行入口 |
| `memory_write` | `via-vault` | V1 阶段所有记忆写入必须经 Vault；Hermes 上线后按方案 3.3 调整 |
| `source_traceable` | true | 产出结论必须可溯源，禁止臆造 |

## 变更纪律

1. 新增/修改 Agent 定义 → 改本目录文件 → 提交 → 对端 pull。
2. 本地未提交的 Agent 改动视为不存在。
3. `entry: true` 的 Agent 若发生变更，必须在提交信息中显著标注。
