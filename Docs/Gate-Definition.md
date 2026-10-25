# Gate-Definition（治理轨第四步 · L92 / A1–A4 门禁校验契约）

> 制定：2026-10-26
> 依据：`Docs/Architecture-Alignment-Decision.md` §4 第 4 项——「Gate 定义：L92 / A1 / A2 / A3 / A4（**判据、触发点、FAIL 行为**）」；
> 并衔接 `Vault/AgentOS/CONSTITUTION.md`（Enforced 四判据、账本不可篡改）、`Docs/TaskStore-Schema.md`（状态机）、`Docs/Ledger-Schema.md`（哈希链与权限映射）。
> **本文档只定契约，不实现 Runtime、不实现 Broker、不创建任何账本数据文件。**

## 1. 定位与口径声明

- 门禁共五个：**L92（总闸）** + **A1–A4（四类 Authenticity 门禁）**。
- 编号沿用目标架构原编号，不重命名（裁决 3）。
- **口径诚实声明**：指令原文对 Gate 的要求是「判据、触发点、FAIL 行为」三要素，未逐条给出细则。本文档是在本仓库内对这五项的**实例化定义**，判据字段沿用 B2/B3 已定契约（TaskStore 状态机、Ledger 哈希链与权限映射）。**若指令原文对某 Gate 有更细判据，以原文为准**，届时按原文对齐修订本文档。
- 当前状态：**DEFINED（已定义）**，**非 Enforced**。标 Enforced 须四判据齐备（规则+机制+自动阻断+绕过测试全 FAIL）。

## 2. 通用契约（五个 Gate 共用）

| 项 | 约定 |
| --- | --- |
| 执行时机 | **阻断式（blocking）**：在状态转换 / 账本写入**之前**执行，禁止先写后判 |
| 判定输出 | `PASS` / `FAIL` / `SKIP` 三值，不引入模糊中间态 |
| 无对象行为 | 校验对象不存在时输出 **`SKIP` 并留痕**，**禁止写 PASS**（对应「绕过测试在无对象时不写」的诚实纪律） |
| FAIL 行为 | ① 阻断本次转换；② 任务落 `BLOCKED` 或 `REJECTED`（按各 Gate 规定）；③ 记录 Decision Ledger（`approved_by=null`、`rule_ref=GATE_FAIL:<编号>`）；④ **保留真实失败**，禁止覆盖、禁止重试洗白 |
| 不可绕过 | Gate 判定发生在写入之前；任何绕过判定直接落盘的行为视为**治理越轨** |
| 例外通道 | 仅用户可批准例外（责任边界见第 4 节），例外必须留痕并进入 Decision Ledger |

## 3. Gate 逐一定义

### 3.1 L92 — 总闸门禁（结构完整性）

| 项 | 内容 |
| --- | --- |
| **触发点** | Task：`CREATED → VALIDATED`；账本：任意写入前 |
| **准入条件** | ① 共同字段齐全（`entry_no`/`prev_hash`/`hash`/`timestamp_utc`/`actor_identity`/`node`/`sig`）；② 类型正确；③ 枚举值合法（`event_type`/`node`/`source` 等）；④ `scope` 在允许范围内；⑤ `parent_task_id` 无环；⑥ 账本条 `entry_no` 连续、`prev_hash` 与上一条 `hash` 匹配（首条为 genesis） |
| **阻断条件**（任一即 FAIL） | 字段缺失 / 类型错误 / 枚举越界 / `scope` 越界 / 成环 / 跳号或重号 / `prev_hash` 不匹配 / 首条非 genesis |
| **FAIL 行为** | 转 `REJECTED`；不修改原状态；记录 Decision Ledger，`rule_ref=GATE_FAIL:L92` |
| **责任边界** | 规则定义＝治理轨（本文档）；执行载体＝Execution Broker（未来）；**当前＝人工按本文档核对**；争议裁决＝用户 |

### 3.2 A1 — 身份门禁（Identity Authenticity）

| 项 | 内容 |
| --- | --- |
| **触发点** | Task：任意 → `DISPATCHED`；账本：写入者身份校验 |
| **准入条件** | ① `actor_identity` 存在且有效；② `source` 合法（在枚举内）；③ 与 TaskStore 记录的 `actor_identity` 一致；④ `node` 匹配 |
| **阻断条件** | 身份缺失 / 身份无效 / 与 Task 记录不一致 / `source` 越界 / `node` 不匹配 / `sig` 非 null（签名机制未落地前非 null 即视为**伪造**） |
| **FAIL 行为** | 保持原状态 + 落 `BLOCKED`；记录原因；`sig` 非 null 时直接 `REJECTED` |
| **责任边界** | 身份真值源＝`Vault/AgentOS/identity.md`（宪法承继）；校验执行＝Broker；身份绑定＝Identity Runtime（**未建，当前以 host 组件名占位，不冒充**） |

### 3.3 A2 — 执行门禁（Execution Authenticity）

| 项 | 内容 |
| --- | --- |
| **触发点** | Task：任意 → `RUNNING` |
| **准入条件** | ① 派发记录已存在（已过 `DISPATCHED`）；② 执行体就绪（如 OpenHands 容器 Up、Canvas 可达）；③ `scope` 与执行体 workspace 一致 |
| **阻断条件** | 无派发记录 / 执行体未就绪 / workspace 与 scope 不匹配 / 任务曾 `QUARANTINED` 且未裁决 |
| **FAIL 行为** | 落 `BLOCKED` + 记录阻塞原因；**禁止在无执行体时标记 RUNNING**（防假执行） |
| **责任边界** | 执行体可用性＝Ops Agent / health-check 只读判定；派发＝Chief via Broker；执行＝OpenHands |

### 3.4 A3 — 证据门禁（Evidence Authenticity）

| 项 | 内容 |
| --- | --- |
| **触发点** | Task：`RUNNING → SUCCEEDED` |
| **准入条件** | ① 产物存在于 `scope` 内；② `evidence_refs` 可核验（路径可达 / 哈希可重算）；③ 相关账本条链完整 |
| **阻断条件** | 产物缺失 / evidence 不可核验 / 哈希链 `CHAIN_BROKEN` / 快照 `SNAPSHOT_DRIFT` |
| **FAIL 行为** | 转 `FAILED`（保留失败记录与日志引用）；**禁止删除后重建**（重建＝新 `task_id`） |
| **责任边界** | 产物＝执行体；证据核验＝Broker；一致性＝Snapshot Ledger |

### 3.5 A4 — 封存门禁（Closure Authenticity）

| 项 | 内容 |
| --- | --- |
| **触发点** | Task：任意 → `CLOSED` |
| **准入条件** | ① 已处于 `SUCCEEDED` / `FAILED` / `REJECTED` 之一；② 终态字段完整；③ 证据已归档 |
| **阻断条件** | 非终态 / 终态字段缺失 / 证据未归档 / 存在未裁决子任务 |
| **FAIL 行为** | 保持原状态；**`CLOSED` 后任何字段修改视为篡改 → 报警** |
| **责任边界** | 关闭权＝用户 > Chief；封存执行＝Broker |

## 4. 责任边界总表

| 角色 / 组件 | 可以做 | 不可以做 |
| --- | --- | --- |
| **用户（阿北）** | 最高裁决权；推翻任何 Gate 判定；批准例外 | 例外须留痕（不受 Gate 阻断，但进 Decision Ledger） |
| **Chief**（M365 Copilot / Home 由 Hermes 代行） | 发起任务、派发、提议关闭 | 自批准跳过 Gate；直接写账本（须经 Broker） |
| **OpenHands**（执行体） | 在 `scope` 内执行编码、产出证据 | 改权威源；无证据自标 SUCCEEDED；建账本 |
| **Ops Agent** | 只读巡检（冲突、Git、日志、一致性） | 默认只读；修复动作需 Chief 派发 |
| **Execution Broker**（未来） | 账本唯一写入入口；Gate 执行载体 | **未建成前不存在，不得由脚本代行写入** |
| **治理轨（本轨）** | 定义规则与 schema | 不实现 Runtime |

## 5. 门禁挂点总表（TaskStore / Ledger）

| 编号 | 性质 | 触发点 | 校验对象 | FAIL 去向 |
| --- | --- | --- | --- | --- |
| L92 | 总闸 | CREATED→VALIDATED；任意账本写入前 | 结构完整性（字段/类型/枚举/scope/无环/链） | REJECTED |
| A1 | 身份 | 任意→DISPATCHED；账本写入 | `actor_identity` / `source` / `node` / `sig` | BLOCKED（伪造→REJECTED） |
| A2 | 执行 | 任意→RUNNING | 派发记录、执行体就绪、workspace | BLOCKED |
| A3 | 证据 | RUNNING→SUCCEEDED | 产物、`evidence_refs`、链完整性 | FAILED |
| A4 | 封存 | 任意→CLOSED | 终态、字段完整、证据归档 | 保持原状态 |

## 6. 不变式挂点（B5 前置登记，本阶段不定义内容）

| 不变式 | 挂接门禁 |
| --- | --- |
| I-1 账本不可绕过 | L92 / A1 / A2 / A3 / A4（每次判定须留账本记录） |
| I-4 决策不可伪造 | A1 / A4 |
| I-5 快照一致性 | A3 / A4 |
| I-6 日志完整性 | 全部（链式校验） |
| I-7 规则自身可校验 | L92（schema 变更走文档→配置→实现） |
| I-2 / I-3 | **待裁决**（用户 2026-10-22 决定保持待裁决，不阻塞建设） |

> B5 须逐条写明「不变式内容 + 校验方式 + FAIL 判据」，不得只登记编号。

## 7. 解禁条件

| 项目 | 解禁前置 |
| --- | --- |
| Gate 可执行 | Execution Broker 建成（统一入口） |
| 绕过测试 BYP-1 / BYP-A2-05 / BYP-S3-03 / BYP-OBS-02 | Broker 与 Gate 真实存在且有可被绕过对象；**写必 FAIL** |
| 标 Enforced | 规则 + 机制 + 自动阻断 + 绕过测试全 FAIL，四判据齐备 |
| `marking_partial_as_enforced` | **永久禁止**，非阶段性 |

## 8. 变更纪律

本契约的任何变更必须走：**先改本文档 → 提交 git → （合流后）再改实现**。不得先改实现再补文档。变更需在文档头部记录版本与日期。

## 9. 明确不做的事（边界声明）

- 不实现任何 Gate 执行代码或校验程序
- 不创建 Execution Broker 或任何 Runtime 构件
- 不创建 `events.jsonl` / `decisions.jsonl` / `snapshots.jsonl` 或任何账本数据文件
- 不写绕过测试用例（无对象时写必假 PASS）
- 不将任何 Gate 标记为 Enforced
- 不接入 MCP / Portal / Runtime 接线
