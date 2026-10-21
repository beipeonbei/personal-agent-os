# Architecture-Gap-Analysis（架构对齐差距分析）

> 日期：2026-10-21
> 定位：**此前那份 Stage 5「Home Node Master Execution Directive」= Target Architecture（目标架构），不是当前仓库状态**
> 基准：**当前仓库实测结果优先**
> 状态：**Stage 5 执行已暂停**，等待本文档完成后的路线裁决

## 0. 定位声明

| 项 | 判定 |
|---|---|
| Stage 5 指令的性质 | **目标架构**（待建设的规格），非现状描述 |
| 当前仓库状态 | 以 2026-10-21 实测为准（见 `Docs/Codebase-Audit-20261021.md`） |
| Stage 5 是否可执行 | ❌ **否**。其依赖的地基在本仓库为零（见第 2 段） |
| 本轮动作 | 只做对齐分析，不实现任何 Runtime / Broker / 账本 |

---

## 1. 当前存在（实测清单）

### 1.1 结构与配置

| 资产 | 实测证据 | 与目标条款的关系 |
|---|---|---|
| 目录标准 12 项（含根 README + .gitignore） | 全库扫描存在 | Evolution Not Replacement 的载体 |
| `Config/system-state.yaml` | 九段状态快照 + audit 段 | **State First** 的状态真源雏形 |
| `Config/home-node.yaml` / `office-node.yaml` | 节点标识与组件状态 | 多节点状态基础 |
| `Agents/roles.yaml` + `agent-schema.md` | 5 agent（1 active / 4 reserved） | Multi-Agent 的 schema 前体 |

### 1.2 知识与身份

| 资产 | 实测证据 |
|---|---|
| `Vault/AgentOS/identity.md` | 存在（1384B）：Vault 权威、冲突 Vault 赢 |
| `Vault/AgentOS/USER.md` | 存在（5180B，九节权威版） |
| `Vault/AgentOS/templates/` 四模板 | Daily Note / Project / Research / Startup Log |
| Vault 六目录结构 | Inbox / Projects / Research / AgentOS / Startup / Daily（五目录仅 `.gitkeep`） |

### 1.3 运行组件（实测在线）

| 组件 | 实测状态 |
|---|---|
| Docker Desktop | 引擎 client/server 均 29.8.2 |
| OpenHands 容器 `openhands` | Up；挂载 `D:\Personal-Agent-OS:/projects`；Canvas 200；`unless-stopped` 自恢复已实证 |
| Hermes Agent v0.21.7 | 运行中（5 进程），Memory 已接管 |
| DSH | 8080 在线（key 401 待用户更换） |
| Git / GitHub | 远端 main，最新 `61378ad`，工作区干净 |

### 1.4 文档与治理雏形

- Docs 17 份（总体方案 / 5 份 runbook / 5 份接入与审计报告 / 索引）
- **已有治理雏形可演进**：
  - `identity.md` 的「Vault 权威、冲突 Vault 赢」≈ **Single Source of Truth**
  - 全项目诚实纪律（未检测写"未复验"、失败保留真实失败、不把 Partial 写 Enforced）≈ **Governance 精神**

---

## 2. 当前缺失（目标要求 vs 仓库实况）

| 目标架构构件 | 仓库实测 | 后果 |
|---|---|---|
| **Constitution** | ❌ 不存在（0 命中） | 无最高规则源，Governance 无依据 |
| **TaskStore Schema** | ❌ 不存在 | Task 无处存放，Broker 无对象 |
| **events.jsonl** | ❌ 全库 `.jsonl` = **0** | Event Authenticity（prev_hash/hash chain）无从建立 |
| **decisions.jsonl** | ❌ 0 | Decision Authenticity 无从建立 |
| **snapshot / snapshot chain** | ❌ 0 | Snapshot Authenticity 无从建立 |
| **Gate L92 / A1 / A2 / A3 / A4** | ❌ 0 命中 | 准入无门禁 |
| **I-1 / I-4 / I-5 / I-6 / I-7 不变式** | ❌ 0 命中，无定义 | 无不可违反项可校验 |
| **Identity Runtime**（identity_scope、Actor Identity、Validation） | ❌ 不存在 | TC-ID-01~04 无对象 |
| **GOALS.md / RULES.md** | ❌ Vault 与 AgentOS 下均无（`Test-Path` 全 False） | Identity 的 USER.md Binding 缺两个绑定对象 |
| **Budget Runtime**（tokens / Ledger / Validation / Extension） | ❌ 不存在 | TC-BUD-01~04 无对象 |
| **Execution Broker** | ❌ 不存在 | Task/Decision/Snapshot/Log 无统一入口 |
| **四类 Authenticity**（hash chain / 签名 / 源验证） | ❌ 不存在 | 无机制可校验 |
| **绕过测试用例**（BYP-1 / BYP-A2-05 / BYP-S3-03 / BYP-OBS-02） | ❌ **无可被绕过的对象** | 测试不成立；写 Enforced 即伪造 |

### 结论（关键）

Stage 5 与 Stage 5.5 所需的**地基四项全部为零**：

```text
Constitution   ❌
TaskStore      ❌
事件/决策账本   ❌（全库 .jsonl = 0）
Gate 定义      ❌
```

因此：**Identity Runtime、Budget Runtime、Execution Broker、绕过测试都无法直接开始**。强行开始只会产出"看起来像"的实现——而绕过测试因为根本没有可绕过的东西，必然是假 PASS。这违反诚实纪律，也不满足 Enforced 的四项判据（规则存在 + 机制存在 + 自动阻断 + 绕过测试全部失败）。

---

## 3. 保留项（与目标原则相容，继续沿用）

| 保留项 | 相容理由 |
|---|---|
| 目录标准 12 项 | Evolution Not Replacement：不推倒重来，在其上补 Kernel 目录 |
| `Config/system-state.yaml` | State First：已是机器可读状态真源雏形，可演化为 State Kernel |
| `Vault/AgentOS/identity.md` | Single Source of Truth：Vault 权威规则正是目标所需，且是 Identity Runtime 的绑定前体 |
| `Vault/AgentOS/USER.md` | Identity Runtime 的 USER.md Binding 直接复用（不需重建） |
| Docs 报告体系（审计 / 接入 / 健康） | Observability：目标 Stage 5.5 的 Log Authenticity 需日志资产，现有报告是可信来源 |
| 诚实纪律（不虚构、失败保留真实失败、Partial 不写 Enforced） | Governance 精神一致，且是 Kernel Readiness 可信的前提 |
| OpenHands 执行层 | 未来 Execution Broker 的执行后端（Broker 管入口，OpenHands 管执行） |
| Hermes 接入成果 | Identity / Memory 载体，Stage 5 的 Actor Identity 可挂 Hermes |
| Beta09 成熟度口径（72/100 分项） | 可作为 Kernel Readiness 之外的工程成熟度评分，继续沿用 |
| 已验证的组件接线（Docker / 挂载 / 自恢复） | 不因改架构而动，降低迁移风险 |

---

## 4. 废弃项 / 重定位项

### 4.1 废弃项：无

**当前仓库没有任何"已实现但被目标架构取代"的构件。** Kernel 相关的（Identity/Budget/Broker/账本）从来没实现过，无物可废。强行写"废弃 X"属于虚构，因此本段如实记为：**无废弃项**。

### 4.2 需重定位 / 冲突项（标 CONFLICT，待裁决）

| 编号 | 冲突 | 详情 | 建议 |
|---|---|---|---|
| **C-1** | **编号冲突** | `Docs/Full-Run-Plan-v2.md` 的「阶段 5 双节点接线 / 阶段 8 MCP / 阶段 9 Multi-Agent」与目标架构 Stage 5（Identity & Budget）/ Stage 8（MCP Foundation）/ Stage 9（Multi-Agent）**同名异义** | v2 编号改称「轨 A 阶段」或整体并入 Stage 编号体系 |
| **C-2** | **时序冲突** | v2 阶段 4「先接 2 个 MCP」vs 目标「MCP Foundation 须在 Kernel Readiness YES 之后」（Governance Before Automation） | 二选一：先治理后 MCP（目标），或先 MCP 后治理（v2） |
| **C-3** | **写入权威源冲突** | v2 的 `memory-export.ps1` 直接写 Vault（权威源）；目标架构下写 Vault 属 Snapshot/Log 范畴，须先立写入规则与签名 | 规则未立前，该脚本降级为「只读快照 + 暂存待审」，或推迟到 Snapshot Authenticity 落地后 |

---

## 5. 迁移路径（三条候选，供裁决）

### 路线 A：Kernel First（严格按目标架构）

```text
Constitution → TaskStore Schema → events/decisions/snapshot 账本 → Gate(L92/A1-A4)
→ I-1/I-4/I-5/I-6 定义 → Identity Runtime → Budget Runtime
→ Execution Broker + 四类 Authenticity → 绕过测试 BYP-* 全 FAIL
→ Kernel Readiness Review → （YES 后）Portal / MCP / Multi-Agent
```

- **与目标原则一致性**：最高（Governance Before Automation）
- **对既有资产复用**：低（几乎从零建地基）
- **风险**：周期长，短期无可见产出；当前空壳问题（Vault 空、无脚本）不会同步改善
- **依赖用户**：需先裁决 Constitution 与 Gate 的口径

### 路线 B：v2 继续（先补齐工程能力）

```text
五个自律脚本 → 占位目录落真配置 → Vault 内容填充 + 日志 → MCP/Agent → 双节点接线 → Runtime → 验收
```

- **与目标原则一致性**：低（先自动化、后治理，与目标 Governance Before Automation 相反）
- **对既有资产复用**：高
- **风险**：与目标架构渐行渐远；账本与签名缺失导致 Identity/Budget 无法可信落地

### 路线 C：双轨（推荐候选）

```text
第一轨（工程补齐，不碰账本/权威源）
  自律脚本（仅 git 同步 / 只读体检 / 备份 / 校验）
  + 占位目录落真运行清单 + Vault 内容填充 + 日志约定
        ↓
第二轨（治理地基，与第一轨并行）
  Constitution → TaskStore → 账本 schema → Gate → 不变式定义
        ↓
合流：Identity Runtime → Budget Runtime → Execution Broker → 绕过测试
        ↓
Kernel Readiness Review → （YES 后）Portal / MCP / Multi-Agent
```

- **与目标原则一致性**：中高（自律能力先行，治理紧随；账本类自动化严格排在治理之后）
- **对既有资产复用**：高（脚本与运行清单直接服务 Kernel）
- **风险**：需严格划界——**第一轨脚本不得写账本、不得写权威源**（否则违反 C-3）
- **依赖用户**：需裁决划界规则与 Constitution 口径

### 裁决点（三选一）

| 裁决项 | 选项 |
|---|---|
| 走哪条路线 | A / B / C |
| C-1 编号 | 统一为 Stage 编号 / v2 改称「轨 A」 |
| C-2 时序 | MCP 在 Kernel YES 之后 / 之前 |
| C-3 写入 | memory-export 降级暂存 / 推迟 / 维持直写（不推荐） |

---

## 6. 对齐完成前禁止实现清单

在路线裁决与地基补齐之前，**以下一律不实现**（用户已明确）：

| 禁止项 | 状态 |
|---|---|
| Identity Runtime（identity_scope、Actor Identity、Validation、Binding） | ⛔ 暂停 |
| Budget Runtime（tokens、Ledger、Validation、Extension） | ⛔ 暂停 |
| Execution Broker | ⛔ 暂停 |
| `events.jsonl` | ⛔ 暂停 |
| `decisions.jsonl` | ⛔ 暂停 |
| 绕过测试 BYP-*（无对象，写必假） | ⛔ 暂停 |
| 把任何 Partial 标为 Enforced | ⛔ 禁止 |

---

## 7. 待裁决项（需用户决定）

1. **路线选择**：A（Kernel First）/ B（v2 继续）/ C（双轨）
2. **Constitution 口径**：由谁定义、包含哪些不可违反项（是否以现有 identity.md + 诚实纪律为基底）
3. **Gate 与不变式**：L92 / A1–A4 与 I-1~I-7 是否采用指令原编号，还是重命名以匹配本仓库
4. **C-1 / C-2 / C-3 三项冲突的取舍**

---

## 附：本分析的可核验性

| 结论 | 核验方式 |
|---|---|
| 全库 `.jsonl` = 0 | `Get-ChildItem -Recurse -Filter '*.jsonl'` → 0 |
| GOALS.md / RULES.md 不存在 | `Test-Path` 于 Vault 与 Vault/AgentOS 下 → 全 False |
| Constitution / TaskStore / Gate / I-* 不存在 | 全库内容检索 `Constitution\|TaskStore\|events.jsonl\|decisions.jsonl\|Gate L92\|identity_scope\|budget_tokens\|Execution Broker\|I-7\|Kernel Readiness` → 0 命中 |
| 组件在线状态 | Docker 29.8.2 / OpenHands Up / Hermes 5 进程 / DSH 8080 |
| 仓库状态 | `61378ad`，工作区干净，与远端 main 一致 |
