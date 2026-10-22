# Portal — Personal Agent Portal 源码预留目录

> **状态：`SPEC_FROZEN / NOT_IMPLEMENTED`**
> 规格已冻结，但**当前不实现、也不开始实现**。本目录只有规格文件，无源码。

Personal Agent Portal 是未来自研的最终 Workbench（OpenHands 是执行中心，Portal 是工作台——论证见 `../Docs/Dual-Node-Personal-Agent-OS-V1.md` 第四部分）。

## 触发条件（满足才允许开工）

依据 `Docs/Architecture-Alignment-Decision.md` 第 5.2 段与第 7 段：

1. **Kernel Readiness Review = YES**（即 I-1 / I-4 / I-5 / I-6 全部 Enforced）
2. Identity Runtime 与 Budget Runtime 已建成
3. Execution Broker 与四类 Authenticity 已建成，绕过测试 BYP-* 全部 FAIL

三条未同时满足前，任何 Portal 开发都属越轨（Governance Before Automation）。

## 文件

| 文件 | 说明 |
| --- | --- |
| `portal-mvp.md` | MVP 规格冻结件（四大中心 / 技术选型 / 红线 / 里程碑） |
| `README.md` | 本说明（含状态与触发条件） |

## 说明

- 原"90 天路线阶段 3 启动开发 / Q4 上线"的表述已作废——时序改由 Kernel Readiness 决定，不由日历决定。
- 开发节点：Home Node 优先；源码随 GitHub 仓库同步。
- 开工前必读：`portal-mvp.md` 与本文件触发条件。
