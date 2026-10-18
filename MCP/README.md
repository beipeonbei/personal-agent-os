# MCP — 统一接入配置目录

本目录管理 Personal Agent OS 所有 MCP（Model Context Protocol）Server 的配置与接入计划。

## 文件

| 文件 | 说明 |
| --- | --- |
| `mcp-plan.md` | 接入清单与纪律（先登记后接入） |
| `README.md` | 本说明 |
| `mcp-<服务名>.json` | 各 Server 配置文件（接入时创建） |

## 规则

1. 新服务接入前必须在 `mcp-plan.md` 登记（服务名/用途/优先级/依赖/状态）。
2. 第一周最低限度接入两个：`filesystem` + `github`（P0）。
3. 凭据不进仓库（`Config/local-*.yaml` 已被 `.gitignore` 排除）。
4. 涉及对外动作的服务（browser / email / calendar）默认只读授权。
