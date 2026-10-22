# Ledger-Schema（治理轨第三步 · 账本存放结构与防篡改契约）

> 制定：2026-10-22 · 裁决依据：`Docs/Architecture-Alignment-Decision.md` 第 2.2 段第 3 步
> **本文档只定 schema 与契约，不写任何实现、不创建任何数据文件。**
> 实现时机：经 Execution Broker 统一入口写入（裁决 C-4、Constitution 第二条）。

## 1. 定位与边界

| 问题 | 结论 |
| --- | --- |
| 三类账本是什么 | 系统的"发生了什么 / 做了什么决定 / 某时刻长什么样"的不可变记录 |
| 与 TaskStore 的关系 | TaskStore 记录任务的存在与状态（B2 已定）；账本记录事实与决定。Task 状态变更事件（TASK_CREATED / VALIDATED / DISPATCHED / CLOSED 等）是 Event Ledger 的事件类型来源 |
| 与 Runtime 的关系 | Identity / Budget Runtime 解禁前，账本只定义、不实例化；绑定身份的字段只登记 |
| 与 Broker 的关系 | 未来所有账本写入**必须经 Execution Broker**；Broker 未建成前，任何写入挂起 |
| 与 Gate 的关系 | Gate 在校验时使用账本作为证据（如 I-4 决策可溯源、I-5 快照一致、I-6 日志完整） |

## 2. 三类账本文件约定（仅命名，不创建）

| 账本 | 文件名（约定） | 内容 |
| --- | --- | --- |
| Event Ledger | `events.jsonl` | 系统事件流，每行一条 |
| Decision Ledger | `decisions.jsonl` | 决策记录，每行一条 |
| Snapshot Ledger | `snapshots.jsonl` | 一致性快照索引，每行一条 |

> **当前状态**：全库 `*.jsonl` = 0（`verify-system.ps1` 的 `boundary_no_jsonl` 项校验通过）。本阶段**禁止创建**这些文件。它们只在 Broker 建成后、schema 冻结后才允许实例化。

## 3. 共同字段（所有账本条目共有）

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `entry_no` | integer | 是 | 账本内顺序号，从 1 递增，不可跳号 |
| `prev_hash` | string(hex) | 是 | 上一条目的 `hash`；首条为固定 genesis 串 |
| `hash` | string(hex) | 是 | 本条 hash（见第 5 节 Hash-Chain Contract） |
| `timestamp_utc` | string(ISO-8601) | 是 | 条目写入时间（系统记录时间，不代表外部事实时间） |
| `actor_identity` | string | 是 | 写入者身份；Identity Runtime 建成前由 host 组件名代替，建成后绑定身份 |
| `node` | enum | 是 | `home` / `office` |
| `sig` | string \| null | 否 | 写入者签名；签名机制落地前恒为 null，不伪造 |

## 4. 三类 Schema 字段

### 4.1 Event Ledger（事件账本）

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `event_type` | enum | 是 | 见 4.1.1 |
| `task_id` | string \| null | 否 | 关联 Task（承接 TaskStore）；非任务事件为 null |
| `object_ref` | string \| null | 否 | 被操作对象（路径 / 资源标识） |
| `payload` | object | 否 | 事件附带的结构化数据 |
| `evidence_ref` | string \| null | 否 | 外部证据（日志路径、产物哈希、快照 id） |

**4.1.1 event_type 枚举**（与 TaskStore 状态机对齐）：
`SYSTEM_BOOT`、`TASK_CREATED`、`TASK_VALIDATED`、`TASK_DISPATCHED`、`TASK_RUNNING`、`TASK_SUCCEEDED`、`TASK_FAILED`、`TASK_BLOCKED`、`TASK_CLOSED`、`TASK_REJECTED`、`TASK_QUARANTINED`、`GATE_CHECK`、`CONFIG_CHANGE`、`MEMORY_EXPORT`、`LEDGER_ROTATE`

### 4.2 Decision Ledger（决策账本）

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `decision_id` | string | 是 | 全局唯一 `DEC-<UTC日期>-<序号>` |
| `proposed_by` | string | 是 | 提议者身份 |
| `approved_by` | string | 是 | 批准者身份（与 `actor_identity` 可不相同） |
| `rule_ref` | string | 是 | 依据的规则（Gate 编号 / Constitution 条款 / 用户裁决） |
| `before_state` | object | 否 | 决策前状态摘要 |
| `after_state` | object | 否 | 决策后状态摘要 |
| `evidence_ref` | string \| null | 否 | 决策支撑证据 |

### 4.3 Snapshot Ledger（快照账本）

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `snapshot_id` | string | 是 | 全局唯一 `SNP-<UTC日期>-<序号>` |
| `scope` | string | 是 | 快照范围（如 `dir-tree:D:/Personal-Agent-OS` / `config:system-state.yaml`） |
| `state_hash` | string(hex) | 是 | 被快照对象的一致性哈希（目录树哈希 / 配置哈希） |
| `verifier` | string | 是 | 生成快照的组件身份 |
| `parent_snapshot` | string \| null | 否 | 上一快照 id（用于对比增量） |

## 5. Hash-Chain Contract（哈希链契约）

目标：任意历史改写都会被检测（tamper-evident）。

**条目哈希算法**：
```
canonical(entry) = 稳定序列化（字段按字典序、无多余空白、UTF-8）
hash(entry) = H(prev_hash || canonical(entry))
H = SHA-256（十六进制小写）
```

**首条约定**：
```
prev_hash(第一条) = "0000000000000000000000000000000000000000000000000000000000000000"  (genesis)
```

**写入契约**：
1. 追加前，新条目的 `prev_hash` 必须等于当前账本最后一条的 `hash`。
2. 新条目写入时即时计算并填充自己的 `hash`。
3. 任何条目的 `prev_hash` / `hash` / 内容被改写，其后整条链 `hash` 全部失配 → 校验失败。
4. 校验规则：`verify-chain` 从首条起逐条重算 `hash`，与存储值比对；不一致即报 `CHAIN_BROKEN`。

**删除/改写禁令**：账本只允许追加，禁止删除或覆盖历史行（Constitution 第二条）。`entry_no` 不可重用。

**签名（未来）**：`sig` 字段在签名机制落地前恒为 null；落地后由写入者用私钥对 `hash` 签名。本阶段不实现、不伪造签名。

## 6. Validation Rules（校验规则）

### 6.1 结构校验（每条写入前）
- 共同字段齐全（entry_no / prev_hash / hash / timestamp_utc / actor_identity / node / sig）
- `entry_no` 等于"末条 + 1"，无跳号、无重复
- `prev_hash` 等于末条 `hash`（首条等于 genesis）
- 类型与枚举值合法（event_type / node / role 等）
- `sig` 为 null（签名机制未落地前）

### 6.2 哈希链校验（周期性 / 读取时）
- 逐条重算 `hash == 存储 hash`
- 逐条 `prev_hash == 上一条 hash`
- 首条 `prev_hash == genesis`
- 失败 → `CHAIN_BROKEN`，拒绝读取该账本后续内容并报警

### 6.3 语义校验
- Event Ledger：`event_type` 在枚举内；`task_id` 关联已存在的 Task（若非 null）
- Decision Ledger：`approved_by` 不得为空；`rule_ref` 必须指向有效规则
- Snapshot Ledger：`state_hash` 可由 `scope` 重算复核（不一致 → `SNAPSHOT_DRIFT`，触发 I-5 复核）

### 6.4 权限校验（见第 7 节）
- 写入者身份经 Authority Mapping 授权；未授权写入 → `UNAUTHORIZED`

## 7. Authority Mapping（写入权限映射）

| 账本 | 允许写入者 | 当前状态 | 约定入口 |
| --- | --- | --- | --- |
| Event Ledger | Execution Broker（代系统组件写） | **挂起**（Broker 未建） | Broker `ledger.append` 接口 |
| Decision Ledger | Chief Agent / 用户裁决通道（经 Broker） | **挂起** | Broker `decision.record` 接口 |
| Snapshot Ledger | Ops Agent / 巡检任务（经 Broker） | **挂起** | Broker `snapshot.capture` 接口 |

**约束**：
- 任何账本写入**不得**由脚本或组件直接落盘；必须经 Execution Broker 统一入口（Constitution 第二条 + 裁决 C-4）。
- `actor_identity` 必须绑定真实身份（Identity Runtime 建成后）；建成前以 host 组件名占位，不冒充。
- 用户始终拥有最高写入权（用户裁决 > 宪法 > 指令）。
- 所有写入须在 `sig` 机制落地后签名；落地前仅允许 null，禁止伪造。

## 8. Gate 与不变式挂点

| 编号 | 挂点 | 校验内容 |
| --- | --- | --- |
| L92 | 任意账本写入 | 结构完整性总闸（第 6.1 节） |
| A1 | 写入者身份 | `actor_identity` 合法且经 Authority Mapping 授权 |
| A3 | 证据链 | 关键事件 `evidence_ref` 可核验 |
| A4 | 终态/封存 | 账本条目封存后不可变 |
| I-1 | 全程 | 账本不可绕过（任何系统动作须有对应 Event/Decision 条目） |
| I-4 | Decision Ledger | 决策不可伪造（每条 Decision 须 approved_by + rule_ref） |
| I-5 | Snapshot Ledger | 快照一致性（state_hash 可复核） |
| I-6 | 三类账本 | 日志完整性（链式校验，CHAIN_BROKEN 即告警） |
| I-7 | 本 schema 自身 | 治理规则可被校验（变更走「文档→配置→实现」） |
| I-2 / I-3 | — | **待裁决**（用户 2026-10-22 决定保持待裁决，不阻塞建设） |

## 9. 与后续步骤的衔接

| 后续 | 本 schema 提供的输入 |
| --- | --- |
| Gate 定义（第 4 步） | 第 8 节已列出每个 Gate 的挂点与校验内容 |
| 不变式定义（第 5 步） | 第 8 节 I-* 映射表；I-2/I-3 待裁决 |
| Identity Runtime | `actor_identity` 绑定目标；`sig` 签名密钥源 |
| Budget Runtime | （账本本身不含预算，预算绑定在 TaskStore 占位字段） |
| Execution Broker | 三类账本的唯一写入入口契约（`ledger.append` / `decision.record` / `snapshot.capture`） |

## 10. 变更纪律

本 schema 的任何变更必须走：**先改本文档 → 提交 git → （合流后）再改实现**。不得先改实现再补文档。变更需在文档头部记录版本与日期。

## 11. 明确不做的事（边界声明）

- 不创建 `events.jsonl` / `decisions.jsonl` / `snapshots.jsonl` 或任何账本数据文件
- 不实现任何读写 / 哈希 / 校验代码
- 不创建 Execution Broker 或任何 Runtime 构件
- 不接入 MCP / Portal / Runtime 接线
