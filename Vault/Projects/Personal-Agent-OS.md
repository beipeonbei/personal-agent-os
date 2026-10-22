# 项目：Personal-Agent-OS

- 状态：**进行中**（Beta 0.9 → V1，路线 C 双轨）
- 代码位置：`D:\Personal-Agent-OS`（git 仓库 `personal-agent-os`，远端 github.com/beipeonbei/personal-agent-os）
- 目标：One Personal Agent OS / Two Nodes / Shared Knowledge / Shared Config / Shared GitOps / Shared Memory
- 本周动作：架构对齐裁决定案 → 轨 A 阶段 1–4a 工程补齐 → 第二轨 Constitution
- 相关链接：`Docs/Architecture-Alignment-Decision.md`、`Docs/Full-Run-Plan-v2.md`、`Docs/Codebase-Audit-20261021.md`

## 当前六层实测

| 层 | 状态 |
| --- | --- |
| Chief Agent | M365 Copilot（Office）／Hermes（Home 代行） |
| Memory Layer | Hermes v0.21.7 运行中 + Vault 权威源 |
| Runtime Layer | DSH 8080 在线，key 401，未接线 |
| Execution Layer | OpenHands 容器 Up，Canvas 200，挂载 OS 全树 |
| Knowledge Layer | Obsidian Vault（六目录，本批次填充中） |
| GitOps Layer | GitHub 同步正常 |

## 工程待办（第一轨）

- [x] 五个自律脚本（Config/scripts/）
- [x] 三目录落真运行清单（OpenHands/Hermes/Harness）
- [ ] Vault 五目录内容填充（本批）
- [ ] 开机自启缺口：Docker Desktop / Hermes 未注册登录启动
- [ ] DeepSeek key（阻塞 Runtime）

## 治理待办（第二轨）

- [ ] Constitution.md
- [ ] TaskStore Schema
- [ ] 账本 schema（events/decisions/snapshot）
- [ ] Gate L92 / A1–A4
- [ ] 不变式 I-1~I-7（I-2/I-3 是否启用待确认）
- [ ] GOALS.md / RULES.md
