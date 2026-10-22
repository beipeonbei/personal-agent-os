# TaskStore-Schema（治理轨第二步 · Task 存放结构与状态机）

> 制定：2026-10-22 · 裁决依据：`Docs/Architecture-Alignment-Decision.md` 第 2.2 段第 2 步
> **本文档只定 schema 与流转规则，不写任何实现、不创建任何数据文件。**
> 实现时机：Execution Broker 建成后，Task 写入必须经由 Broker 统一入口（裁决 C-4）。

## 1. 定位与边界

| 问题 | 结论 |
| --- | --- |
| TaskStore 是什么 | Task 的结构化存放与状态机定义，是治理对象，不是执行通道 |
| 与 `events.jsonl` / `decisions.jsonl` 的关系 | **不同对象**。TaskStore 记录"任务的存在与状态"；events/decisions 记录"发生了什么事、做了什么决定"。后者的 schema 属治理轨第 3 步，另行定案 |
| 与 Execution Broker 的关系 | 未来所有 Task 写入**必须经 Broker**；本 schema 定案先于 Broker 实现，Broker 实现时按本 schema 校验 |
| 与 Gate 的关系 | Gate 校验挂在状态流转上（见第 5 节），Task 数据本身不是 Gate 的账本 |
| 与 Runtime 的关系 | Identity / Budget Runtime 解禁前，本 schema 中的身份与预算字段只登记、不实现 |

## 2. Task 字段定义（schema）

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `task_id` | string | 是 | 全局唯一，建议 `TSK-<UTC日期>-<序号>` |
| `created_utc` | string(ISO-8601) | 是 | 创建时间，**系统记录时间，不代表外部事实时间** |
| `source` | enum | 是 | `chief` / `hermes` / `user` / `ops`；无来源的 Task 不得创建 |
| `actor_identity` | string | 是 | 发起者身份标识；Identity Runtime 建成前由 host 组件名代替，建成后改为绑定身份 |
| `node` | enum | 是 | `home` / `office`；双节点 Task 归属 |
| `parent_task_id` | string \| null | 否 | 子任务指向父任务；形成任务树，禁止环 |
| `title` | string | 是 | 一句话目标 |
| `scope` | string | 是 | 允许操作的目录/资源范围（如 `D:/Personal-Agent-OS/Projects/<topic>`） |
| `status` | enum | 是 | 见第 3 节状态机 |
| `created_by_entry` | string | 是 | 创建入口（如 `codebuddy-session`、`hermes-desktop`） |
| `updated_utc` | string | 是 | 最后一次状态变更时间 |
| `budget_tokens` | integer \| null | 否 | **占位字段**：预算上限；Budget Runtime 解禁前只登记不校验 |
| `budget_ledger_ref` | string \| null | 否 | **占位字段**：预算账本引用；解禁前恒为 null |
| `evidence_refs` | list | 否 | 关联证据（账本哈希、日志路径、产物路径） |
| `note` | string | 否 | 自由备注 |

## 3. 状态机

```text
CREATED ──> VALIDATED ──> DISPATCHED ──> RUNNING ──> SUCCEEDED ──> CLOSED
   │            │              │             │
   │            │              │             ├──> FAILED ─────> CLOSED
   │            │              │             └──> BLOCKED ────> CLOSED
   │            │              │
   │            │              └──（派发前发现范围/身份不合法）──> REJECTED
   │            │
   │            └──（结构校验失败：缺字段/成环/scope 越界）──> REJECTED
   │
   └──（来源不明或身份无效）──> REJECTED

任意状态 ──（发现与已封存事实冲突或数据可疑）──> QUARANTINED
```

| 状态 | 含义 |
| --- | --- |
| CREATED | 已创建，未校验 |
| VALIDATED | 结构校验通过（字段完整、scope 合法、无环） |
| DISPATCHED | 已派发给执行体（OpenHands 等） |
| RUNNING | 执行体正在执行 |
| SUCCEEDED | 执行成功，产物已落 |
| FAILED | 执行失败，保留失败记录 |
| BLOCKED | 因外部条件阻塞（如等待 key、等待审批），保留阻塞原因 |
| CLOSED | 终态，任务关闭 |
| REJECTED | 校验不通过被拒，不进入执行 |
| QUARANTINED | 隔离态，待人工裁决 |

**禁止的状态跳跃**：CREATED 不得直接到 RUNNING（必须过 VALIDATED → DISPATCHED）；REJECTED / CLOSED 是终态，不得再流转。

## 4. 流转规则

1. **创建即校验**：CREATED → VALIDATED 必须检查字段完整性、`scope` 是否在允许范围内、`parent_task_id` 无环。
2. **身份先行**：`actor_identity` 无效的 Task 直接 REJECTED，不得进入 DISPATCHED。
3. **派发留痕**：DISPATCHED 时必须记录执行体标识；执行体未就绪时停在 BLOCKED，不得假装 RUNNING。
4. **失败保留**：FAILED 必须保留失败原因与日志引用，禁止删除后重建（重建 = 新 task_id）。
5. **终态不可逆**：CLOSED 后不得修改任何字段；需要补充信息只能新建子任务并引用。

## 5. Gate 与不变式挂点

| 编号 | 挂点 | 校验内容 |
| --- | --- | --- |
| L92 | CREATED → VALIDATED | 结构完整性总闸：字段、scope、无环 |
| A1 | 任意 → DISPATCHED | `actor_identity` 与 `source` 合法 |
| A2 | 任意 → RUNNING | 执行体就绪且派发记录存在 |
| A3 | RUNNING → SUCCEEDED | 产物存在且 `evidence_refs` 可核验 |
| A4 | 任意 → CLOSED | 终态字段冻结校验 |
| I-1 | 全程 | 事件/决策账本不可绕过（Task 状态变更须有账本记录——**待账本 schema 定案后启用**） |
| I-4 | 全程 | 决策不可伪造（Task 的派发/关闭决定须可溯源——待 Broker 后启用） |
| I-5 | 任意写操作 | 快照一致性（Task 关键状态可快照比对——待 Broker 后启用） |
| I-6 | 全程 | 日志完整性（Task 生命周期日志不可篡改——待 Broker 后启用） |
| I-7 | 全程 | 治理规则自身可被校验（本 schema 的变更走「文档→配置→实现」） |
| I-2 / I-3 | — | **待裁决**（目标架构验收清单未点名，用户 2026-10-22 决定保持待裁决，不阻塞建设） |

## 6. 与后续步骤的衔接

| 后续 | 本 schema 提供的输入 |
| --- | --- |
| 治理轨第 3 步（账本 schema） | Task 状态变更事件（TASK_CREATED / VALIDATED / DISPATCHED / CLOSED 等）作为 events 的事件类型来源 |
| Gate 定义（第 4 步） | 第 5 节已列出每个 Gate 的挂点与校验内容 |
| 不变式定义（第 5 步） | 第 5 节 I-* 映射表；I-2/I-3 待裁决 |
| Identity Runtime | `actor_identity` 字段的绑定目标 |
| Budget Runtime | `budget_tokens` / `budget_ledger_ref` 两个占位字段 |
| Execution Broker | Task 写入入口契约；本 schema 即 Broker 的校验依据 |

## 7. 变更纪律

本 schema 的任何变更必须走：**先改本文档 → 提交 git → （合流后）再改实现**。不得先改实现再补文档。变更需在文档头部记录版本与日期。

## 8. 明确不做的事（边界声明）

- 不创建 `taskstore.jsonl` 或任何 Task 数据文件
- 不实现任何读写代码
- 不创建 Gate 或不结婚不变式的可执行校验
- 不接入 MCP / Portal / Runtime
