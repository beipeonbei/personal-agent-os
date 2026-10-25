# Docs — 方案文档目录

Personal Agent OS 的全部架构级文档，随 GitHub 仓库同步（GitOps Sync）。

## 文件

| 文件 | 说明 |
| --- | --- |
| `Dual-Node-Personal-Agent-OS-V1.md` | **主文档**：双节点架构、节点职责与安装顺序、四层同步、OpenHands 定位论证、Portal MVP、第一周检查表、90 天路线图、12 个月路线、V1 MVP 六组件取舍 |
| `README.md` | 本说明 |

## 架构治理类（按裁决优先级排序，冲突时上者赢）

| 文件 | 说明 |
| --- | --- |
| `Architecture-Alignment-Decision.md` | **裁决文档**（2026-10-22）：路线 C 双轨、Constitution 以 identity.md + 诚实纪律为基底、编号沿用 L92/A1-A4/I-1~I-7、C-3 维持直写 Vault 及其四条补偿纪律；双轨划界规则、合流顺序、七项禁止的解禁条件；新识别冲突 C-4 / C-5 待裁决 |
| `Architecture-Gap-Analysis.md` | **差距分析**（2026-10-21）：目标架构 vs 仓库实测；地基四项全为零；保留项清单；三路线候选与裁决点 |
| `TaskStore-Schema.md` | **治理轨 B2**（2026-10-22）：Task 字段定义与状态机（CREATED→…→CLOSED，含 REJECTED/QUARANTINED），Gate 与不变式挂点；仅 schema，无实现、无数据文件 |
| `Ledger-Schema.md` | **治理轨 B3**（2026-10-22）：Event / Decision / Snapshot 三类账本 Schema、Validation Rules、Hash-Chain Contract（SHA-256 链）、Authority Mapping（全部经 Broker 写入）；仅定义，禁止创建 `.jsonl` |
| `Gate-Definition.md` | **治理轨 B4**（2026-10-26）：L92 总闸 + A1–A4 四类门禁的准入条件、阻断条件、状态转换规则、责任边界；状态 DEFINED，可执行须等 Execution Broker |
| `Full-Run-Plan-v2.md` | **轨 A 计划**：阶段 1–7（现称轨 A 阶段 1–7）工程补齐方案；顶部有编号注记，与裁决文档冲突处以裁决文档为准 |
| `Codebase-Audit-20261021.md` | **审计基线**：12 个薄弱点 W1–W12 与成熟度 72/100 分项 |

> 注：本目录其余文档（各组件接入报告、健康检查、runbook、KPI 等）属实测记录与操作手册，不列入治理裁决链。裁决优先级为：用户逐项裁决 > `Architecture-Alignment-Decision.md` > 目标架构指令 > `Full-Run-Plan-v2.md` > 其他 Docs。

## 维护纪律

1. 架构变更顺序：**先改文档 → 再改配置 → 后改实现**。
2. 文档中的目录标准（附录 A）与物理目录、根 `README.md` 三处必须逐字一致。
3. 本文档是双节点一致性的最高依据；两端冲突以 GitHub 仓库最新提交为准。
