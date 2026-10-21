# Architecture-Alignment-Decision（架构对齐裁决）

> 日期：2026-10-22
> 依据：`Docs/Architecture-Gap-Analysis.md` 第 5 段（迁移路径）与第 7 段（待裁决项）
> 裁决人：阿北（用户，逐项选择）
> 效力：本文档是路线 C 双轨的**唯一执行依据**；与 `Full-Run-Plan-v2.md` 冲突处以本文档为准
> 状态：**四项裁决已定案**；地基仍为 MISSING，解除 Stage 5 暂停的前置是第 2.2 段完成

---

## 1. 四项裁决结果

| 裁决项 | 结果 | 备注 |
|---|---|---|
| 路线 | **C 双轨** | 第一轨工程补齐与第二轨治理地基并行，合流后才做 Runtime 构件 |
| Constitution 口径 | **以 `identity.md` + 诚实纪律为基底演进** | 不另起独立宪法，不推倒重来（Evolution Not Replacement） |
| Gate 与不变式编号 | **沿用原编号 L92 / A1–A4 / I-1~I-7** | 与目标架构指令逐字一致，另附「编号 → 本仓库落点」对照表 |
| C-3 写入冲突 | **维持 memory-export 直写 Vault** | 用户裁决；已知风险与补偿纪律见第 6 段 |

C-1 与 C-2 不单独裁决，由路线 C 推导（见第 5 段）。

---

## 2. 路线 C：双轨执行划界

### 2.1 第一轨 · 工程补齐

**范围**：`Full-Run-Plan-v2.md` 的阶段 1（五个自律脚本）、阶段 2（占位目录落真运行清单）、阶段 3（Vault 内容填充 + 日志约定）。

**硬约束（划界规则，违反即算越轨）**：

1. **不得写账本**：第一轨任何脚本不得创建或写入 `events.jsonl`、`decisions.jsonl`、snapshot 链。账本属第二轨产物，schema 未定前写入即为不可追溯数据。
2. **不得写权威源**：第一轨脚本不得改写 `Vault/AgentOS/identity.md`、`USER.md`、`GOALS.md`、`RULES.md`。
   - **例外**：`memory-export.ps1` 依 C-3 裁决维持直写 `Vault/AgentOS/memory-export/`，该例外仅覆盖导出目录，不扩展到上述四个文件。
3. **不得建 Runtime 构件**：Identity Runtime、Budget Runtime、Execution Broker 一律不碰（见第 9 段解禁条件）。
4. **只读优先**：`health-check.ps1`、`verify-system.ps1` 必须为只读，仅输出 PASS/FAIL，不得触发写入或修复动作。
5. **编码纪律**：脚本纯 ASCII 英文注释（PowerShell 5.1 读取无 BOM UTF-8 中文会乱码，W12）；YAML/MD 维持 UTF-8。

### 2.2 第二轨 · 治理地基（严格顺序，前项未立不得跳）

```text
1. Constitution（以 identity.md + 诚实纪律为基底，见第 3 段）
2. TaskStore Schema（Task 存放结构与状态机定义）
3. 账本 schema：events.jsonl / decisions.jsonl / snapshot
   —— 先定 schema 与字段，再谈写入；写入实现排在 Broker 之后
4. Gate 定义：L92 / A1 / A2 / A3 / A4（判据、触发点、FAIL 行为）
5. 不变式定义：I-1 ~ I-7（逐条写明校验方式）
6. Identity Binding 缺失文件：GOALS.md / RULES.md
```

第 1–5 步只产出**规则与 schema 文档**，不产出 Runtime 实现。

### 2.3 合流（两轨都到位后）

```text
Identity Runtime → Budget Runtime → Execution Broker + 四类 Authenticity
→ 绕过测试 BYP-* 全 FAIL → Kernel Readiness Review
→ （YES 后）Portal / MCP Foundation / Multi-Agent
```

绕过测试在 Broker 与门禁真实存在前**不写**——无对象时写必假 PASS，违反诚实纪律。

---

## 3. Constitution 基底（裁决 2）

### 3.1 直接承继的既有条款

| 条款来源 | 原文要点 | 宪法中的角色 |
|---|---|---|
| `Vault/AgentOS/identity.md` 第 3 行 | 本文件是 Identity 权威源；冲突时本文件赢，Hermes 侧对齐 | **Single Source of Truth** 条款 |
| `identity.md`「记忆分流规则」第 3 条 | 冲突裁决 Vault 赢，当天对齐 Hermes 侧 | **冲突裁决程序** |
| `identity.md`「变更纪律」 | 改身份/规则：先改本文件 → 提交 → 同步下游 | **变更顺序条款**（文档→配置→实现） |
| `identity.md`「记忆分流规则」第 4 条 | Hermes 配置含密钥禁止入仓 | **密钥隔离条款** |
| 全项目诚实纪律 | 未检测写「未复验/受限」；失败保留真实失败；Partial 不写 Enforced | **Governance 核心条款** |
| `Docs/README.md` 维护纪律 | 先改文档 → 再改配置 → 后改实现 | **演进顺序条款** |
| `Full-Run-Plan-v2.md` 硬约束 1–2 | 不新增组件、不装新软件、不重设计六层架构 | **范围约束条款** |

### 3.2 必须补写的条款（既有条款未覆盖）

| 待补条款 | 内容 | 依据 |
|---|---|---|
| 权威源写入纪律 | 谁可写 `identity.md` / `USER.md` / `GOALS.md` / `RULES.md`，写入须留痕 | **C-3 补偿**（见第 6 段） |
| 账本不可篡改 | `events.jsonl` / `decisions.jsonl` 只追加，禁止改写与删除历史行 | Event / Decision Authenticity 前置 |
| Enforced 四判据 | 规则存在 + 机制存在 + 自动阻断 + 绕过测试全 FAIL，四项齐备才可标 Enforced | 差距分析第 2 段结论 |
| 双轨划界 | 第一轨脚本不得写账本、不得写权威源（除 memory-export 例外） | 本文档第 2.1 段 |
| 裁决优先级 | 用户逐项裁决 > 本决策文档 > 目标架构指令 > v2 计划 > 其他 Docs | 避免再次出现同名异义争议 |

### 3.3 落点

`Vault/AgentOS/CONSTITUTION.md`（与 `identity.md` 同级，属权威源）。`identity.md` 保留不改，宪法在其之上引用它，不复制其内容。

---

## 4. 编号口径（裁决 3）

沿用目标架构原编号，不重命名。另立对照表，每项标注本仓库落点；落点未建则如实标 **待建**，不填占位路径。

| 原编号 | 性质 | 本仓库落点 | 状态 |
|---|---|---|---|
| L92 | Gate | 待建 | MISSING |
| A1 / A2 / A3 / A4 | Gate | 待建 | MISSING |
| I-1 | 不变式 | 待建（无定义） | MISSING |
| I-2 / I-3 | 不变式 | 目标指令中未列入验收项，定义时须先确认是否启用 | 待确认 |
| I-4 / I-5 / I-6 / I-7 | 不变式 | 待建（无定义） | MISSING |
| BYP-1 / BYP-A2-05 / BYP-S3-03 / BYP-OBS-02 | 绕过测试 | 合流后建，此前不写 | 禁止提前 |

**注**：I-1~I-7 在本仓库从未有定义（全库 0 命中）。第二轨第 5 步须逐条写明「不变式内容 + 校验方式 + FAIL 判据」，不得只登记编号就算完成。I-2 / I-3 是否启用需你确认——目标指令的验收清单只点名了 I-1/I-4/I-5/I-6/I-7。

---

## 5. C-1 / C-2 处置（由路线 C 推导）

### 5.1 C-1 编号冲突 → 合并口径

v2 的「阶段 N」统一改称 **轨 A 阶段 N**，全文附 Stage 对照表。两套编号并存但语义唯一：轨 A 阶段 = v2 工程补齐序，Stage = 目标架构序。

| v2 原编号 | 新称 | 对应 Stage / 轨道 |
|---|---|---|
| 阶段 0 审计与方案落盘 | 轨 A 阶段 0 | ✅ 已完成 |
| 阶段 1 自律脚本 | 轨 A 阶段 1 | 第一轨 |
| 阶段 2 占位目录落真 | 轨 A 阶段 2 | 第一轨 |
| 阶段 3 知识层与日志 | 轨 A 阶段 3 | 第一轨 |
| 阶段 4 MCP 接入与 Agent 激活 | **拆分为 4a / 4b** | 见 5.2 |
| 阶段 5 双节点接线 | 轨 A 阶段 5 | 第一轨，需单独批准（见 8 段 C-5） |
| 阶段 6 Runtime 接线 | 轨 A 阶段 6 | **推迟**（见 8 段 C-4） |
| 阶段 7 全量验收 | 轨 A 阶段 7 | 合流后 |

`Full-Run-Plan-v2.md` 须加顶部注记指向本文档；不重写正文（保留历史决策痕迹）。

### 5.2 C-2 时序冲突 → 目标时序优先

MCP Foundation 排在 **Kernel Readiness Review = YES 之后**（Governance Before Automation）。

v2 阶段 4 因此拆分：

- **4a（第一轨可做）**：`roles.yaml` 的 `coding` 转 active、`research`/`ops` 的 host 由 `tbd` 改为 `hermes`、每个 reserved 补 `activation_condition`；`Portal/` 标 `SPEC_FROZEN / NOT_IMPLEMENTED` + 触发条件。这些是配置与状态标注，不建执行入口。
- **4b（推迟到 Kernel YES 后）**：接入 `filesystem` / `github` 两个 MCP，落 `MCP/mcp-*.json`。MCP 是外部能力接入，属自动化，必须晚于治理。

---

## 6. C-3 处置：维持直写 Vault（裁决 4）

### 6.1 裁决与已知风险

`memory-export.ps1` 维持 v2 原设计，直接写 `Vault/AgentOS/memory-export/YYYY-MM-DD.md`。

**如实登记的风险（不因裁决而消失）**：

1. 在 snapshot 签名与源验证机制落地前，该写入**不可追溯**——无法证明某天的导出内容出自哪次运行、是否被中途改写。
2. Vault 是权威源（`identity.md` 第 3 行）。直写权威源而无写入规则，等于权威源可被无留痕变更；后续 Snapshot Authenticity 建立时，此前产生的导出文件**无法补签**，只能标为「历史未签名」。
3. 与第二轨第 3 步（账本 schema）存在时间差：schema 定案前导出的文件，格式可能需要事后迁移。

### 6.2 补偿纪律（裁决的附带条件）

维持直写的前提是以下四条同时成立，任一违反即回到「降级暂存」方案：

1. **目录隔离**：只允许写 `Vault/AgentOS/memory-export/`，禁止写 Vault 其他任何路径，尤其禁止碰 `identity.md`、`USER.md`、`GOALS.md`、`RULES.md` 与知识区。
2. **只追加不覆盖**：文件名带日期，同日重跑追加序号（`-r2`），禁止覆盖已有文件。
3. **写入自留痕**：每次导出在文件头写入生成时间、来源路径、Hermes 进程标识（非签名，仅为将来对账留线索）。
4. **Constitution 立条**：第 3.2 段「权威源写入纪律」条款必须在第二轨第 1 步写入宪法，把本例外显式登记为例外，而非默认许可。

### 6.3 状态标记

`memory-export.ps1` 建成时状态标 **PARTIAL**（机制存在、签名缺失），禁止标 Enforced。

---

## 7. 双轨推进顺序（可执行版）

```text
第一轨（无外部依赖，可立即开工）
  轨 A 阶段 1  五个自律脚本（划界：只读为主，禁写账本与权威源）
  轨 A 阶段 2  OpenHands / Hermes / Harness 三目录落真运行清单
  轨 A 阶段 3  Vault 五空目录各 ≥1 篇真实笔记 + Logs 日志约定
  轨 A 阶段 4a roles.yaml 补齐 + Portal 状态标注

第二轨（与第一轨并行，需先定 Constitution 口径细节）
  Constitution → TaskStore Schema → 账本 schema → Gate(L92/A1-A4) → I-1~I-7 定义 → GOALS.md / RULES.md

合流（两轨都到位）
  Identity Runtime → Budget Runtime → Execution Broker + 四类 Authenticity
  → BYP-* 全 FAIL → Kernel Readiness Review
  → YES 后：Portal / MCP(4b) / Multi-Agent / 轨 A 阶段 6 / 阶段 7
```

---

## 8. 落库过程中新识别的冲突（待裁决，本文档不自行处置）

映射 v2 阶段到双轨时发现两项，`Architecture-Gap-Analysis.md` 未覆盖。按诚实纪律如实登记，不擅自决定：

| 编号 | 冲突 | 详情 | 影响 |
|---|---|---|---|
| **C-4** | **执行入口重叠** | v2 阶段 6 要打通「Chief → Harness → OpenHands」派发链；而 Execution Broker 的定义正是 Task/Decision/Snapshot/Log 的**统一入口**。Broker 未建成前先建派发链，等于绕过统一入口另立一条执行路径，事后要么废弃要么形成双入口 | 建议阶段 6 推迟到 Broker 之后（第 7 段已按此排布），但需你确认 |
| **C-5** | **权威源物理位置变更** | v2 阶段 5 要把 Vault 真实内容移入 OneDrive 并用 junction 回指 D 盘路径。这是移动权威源目录本身，虽不改内容，但在快照与签名机制缺失时执行，Vault 的完整性无从校验；且 junction 后 git 与 Obsidian 的行为需重新实测 | 建议排在第二轨账本 schema 之后，或至少执行前后各做一次全量校验 |

两项均**不阻塞第一轨与第二轨当前工作**，但会在轨 A 阶段 5、6 触发前变成阻塞项。

---

## 9. 解禁条件（何时可以碰 Runtime）

`Config/system-state.yaml` 的 `alignment.forbidden_until_aligned` 七项，按下列条件逐项解除：

| 禁止项 | 解禁条件 |
|---|---|
| `events.jsonl` / `decisions.jsonl` | 第二轨第 3 步 schema 定案（先 schema，后写入实现） |
| `identity_runtime` | 第二轨第 1–5 步全部完成 + `GOALS.md`/`RULES.md` 存在 |
| `budget_runtime` | 同上 |
| `execution_broker` | Identity 与 Budget Runtime 均建成 |
| `bypass_tests` | Broker 与 Gate 真实存在且有可被绕过的对象 |
| `marking_partial_as_enforced` | **永久禁止**，非阶段性约束；Enforced 须满足第 3.2 段四判据 |

---

## 10. 待你确认的三个细节（不阻塞开工）

1. **I-2 / I-3 是否启用**：目标指令验收清单只点名 I-1/I-4/I-5/I-6/I-7，但裁决沿用「I-1~I-7」全段。第二轨第 5 步需要知道是定义 7 条还是 5 条。
2. **C-4 / C-5 的处置**：是否同意按第 8 段建议（阶段 6 推迟到 Broker 后、阶段 5 排在账本 schema 后）。
3. **Constitution 落点确认**：`Vault/AgentOS/CONSTITUTION.md` 与 `identity.md` 同级，是否符合你对权威源布局的预期。

---

## 附：本裁决的可核验性

| 结论 | 核验方式 |
|---|---|
| 四项裁决来自用户逐项选择 | 本轮澄清卡四问四答，选项文本见第 1 段 |
| `identity.md` 承继条款原文 | `Vault/AgentOS/identity.md` 第 3、21–24、26–29 行 |
| v2 阶段编号原文 | `Docs/Full-Run-Plan-v2.md` 阶段 0–7 各节标题 |
| I-1~I-7 在本仓库无定义 | 全库检索 `I-1\|I-4\|I-5\|I-6\|I-7` → 0 命中（差距分析附录已验） |
| 裁决落库 | `Config/system-state.yaml` 的 `alignment.decisions` 段 |
