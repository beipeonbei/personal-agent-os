# Personal Agent Portal — MVP 规格

> **当前状态：未开发。本文件是 MVP 规格冻结件，确保 Q4 启动开发时不返工。**
> 完整设计论证见 `../Docs/Dual-Node-Personal-Agent-OS-V1.md` 第五部分。

## 定位

Personal Agent Portal 是未来自研的**最终 Workbench**（承接方案第四部分论证：OpenHands 是执行中心，最终工作台由 Portal 承担）。本地优先，单机可跑，Home Node 先行。

## 四大中心

### 首页（Today）
Today 任务 / Projects / Tasks / Memory 摘要 / Agents 一览 / Research 索引。

### Agent Center
Research / Coding / Browser / Ops 四 Agent 的状态与任务队列（V1 仅 Chief 在岗，其余预留展示）。

### Memory Center
Identity（`../Vault/Identity/`）/ Knowledge（`../Vault/Knowledge/`）/ Long-term Memory（`../Vault/Long-term/`）——只读索引 + 统计。

### Runtime Center
Agent Status / Harness 状态（未安装，占位）/ MCP 连接状态 / Logs（只读 `../Logs/`）。

## 技术选型（MVP）

- 后端：轻量 API 服务（Python FastAPI），单进程本地运行。
- 前端：静态页 + 少量交互，不引重框架。
- 数据：不建新数据库，直读 `D:\Personal-Agent-OS` 目录与文件；GitHub 状态走 API。
- 部署：Home Node 先行；源码随 GitHub 同步，Office Node 可随时拉起。

## 红线

1. Portal 只做“收敛展示 + 轻操作”，不替代 Chief 的判断。
2. 不直连 Memory 写入——写入仍走 Obsidian 与 Agent Config Sync 既有通道。
3. 不引入需要外部服务才能运行的重依赖（本地优先）。

## 里程碑

- M1（Q4 前 4 周）：首页 + Memory Center 只读版。
- M2（Q4 后 4 周）：Agent Center + Runtime Center 只读版 + 轻操作（任务单下发）。
- M3（12 个月后）：随 Hermes / Harness 上线接入真实运行时状态。
