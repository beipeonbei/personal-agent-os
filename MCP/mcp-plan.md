# MCP 统一接入计划

MCP（Model Context Protocol）是 Personal Agent OS 连接外部能力的统一层。所有 MCP Server 的接入在此登记，Agent 的 `tools` 字段引用本表中的服务。

## 接入清单

| 服务 | 用途 | 优先级 | 依赖 | 状态 |
| --- | --- | --- | --- | --- |
| `filesystem` | 读写 `D:\Personal-Agent-OS` 限定范围 | P0（第一周） | 无 | 计划中 |
| `github` | 仓库操作、项目状态读取 | P0（第一周） | Git + token | 计划中 |
| `obsidian` | Vault 读写（知识检索与沉淀） | P1（第 2–4 周） | Obsidian 本地 API | 计划中 |
| `browser` | 浏览器任务（Research / Browser Agent） | P2（Q2） | 浏览器运行时 | 计划中 |
| `email` | 邮件读取与摘要（研究线索） | P3（Q2–Q3） | 邮箱授权 | 计划中 |
| `calendar` | 日程读取（Today 面板） | P3（Q3） | 日历授权 | 计划中 |

## 接入纪律

1. **先登记后接入**：任何新 MCP Server 必须先在本文档加行（服务名/用途/优先级/依赖/状态），再改配置。
2. 配置文件按服务分文件放本目录，命名 `mcp-<服务名>.json`。
3. 凭据（token 等）不进仓库：放 `Config/local-*.yaml`（已被根 `.gitignore` 排除）或系统凭据管理器。
4. 每个接入的 Server 必须在 `../Logs/` 留一次连通性验证记录。
5. Browser / Email / Calendar 涉及对外动作的 Server，默认只读授权，写操作需 Chief 显式派发。

## 与各组件的对应

- Chief（M365 Copilot）：经会话使用，不直接托管 MCP 配置；
- OpenHands：任务执行时按需调用 `filesystem` / `github` / `browser`；
- Portal Runtime Center：读取各 Server 连接状态（Q4）。
