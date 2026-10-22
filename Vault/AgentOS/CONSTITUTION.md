# CONSTITUTION（Personal Agent OS 宪法）

> 制定：2026-10-22 · 裁决依据：`Docs/Architecture-Alignment-Decision.md`
> 定位：以 `identity.md` + 全项目诚实纪律为基底**演进**而成，不另起独立宪法、不推倒重来（Evolution Not Replacement）。
> 本文件**不复制** `identity.md` 正文，只引用其条款；`identity.md` 保留不改，本宪法在其之上引用它。
> 效力顺序：用户逐项裁决 > 本宪法 > 目标架构指令 > v2 计划 > 其他 Docs。

---

## 一、承继条款（直接沿用既有约定）

| 条款 | 内容 | 来源 |
| --- | --- | --- |
| **单一真源** | Vault 是 Identity / 知识 / 结论的权威源；冲突时 Vault 赢 | `identity.md`「系统身份」与本文件定位声明 |
| **冲突裁决程序** | 冲突裁决 Vault 赢，当天对齐 Hermes 侧 | `identity.md`「记忆分流规则」 |
| **变更顺序** | 先改文档 → 再改配置 → 后改实现 | `identity.md`「变更纪律」、`Docs/README.md` 维护纪律 |
| **密钥隔离** | Hermes 配置含密钥禁止入仓；只本地备份 | `identity.md`「记忆分流规则」 |
| **诚实纪律（Governance 核心）** | 未检测到的写「未复验 / 受限」；失败保留真实失败；Partial 不写 Enforced | 全项目既有纪律 |
| **范围约束** | 不新增组件、不装新软件、不重新设计六层架构 | `Docs/Full-Run-Plan-v2.md` 硬约束 1–2 |

---

## 二、补写条款（既有约定未覆盖，本宪法新增）

### 1. 权威源写入纪律

- 权威源文件限定：`identity.md`、`USER.md`、`GOALS.md`、`RULES.md`。
- 写入须**留痕**：先在 Vault 内改动并提交 git，再同步下游（Hermes 侧等），不得反向由下游覆盖 Vault。
- 任何自动化脚本**不得**写入上述四个文件；唯一例外见第三条。
- GOALS.md 与 RULES.md 目前**不存在**，按第二轨第 6 步补齐；补齐前 Identity Binding 视为不完整。

### 2. 账本不可篡改

- `events.jsonl` 与 `decisions.jsonl` **只追加**，禁止改写或删除历史行。
- 写入实现必须晚于 schema 定案（第二轨第 3 步），且必须经由 Execution Broker。
- 在 schema 与 Broker 建成前，**任何账本文件都不允许出现**；`verify-system.ps1` 对此做机器校验（全库 `.jsonl` = 0）。

### 3. C-3 例外：memory-export 直写（显式登记为例外，非默认许可）

`Config\scripts\memory-export.ps1` 允许直接写 `Vault\AgentOS\memory-export\`，须同时满足：

1. **目录隔离**：只写该目录，禁止写 Vault 其他路径，尤其禁止碰四个权威源文件与知识区。
2. **只追加不覆盖**：文件名 `YYYY-MM-DD.md`，同日重跑追加 `-r2/-r3`。
3. **写入自留痕**：文件头记录生成时间、来源路径、Hermes 进程标识（**非签名**，仅为将来对账留线索）。
4. **状态标记**：该能力状态为 **PARTIAL**（机制存在、签名缺失），**禁止标 Enforced**。

任一违反 → 立即回退为「只读快照 + 暂存待审」方案。
已知风险不因本例外而消失：签名机制落地前，历史导出文件**不可补签**，只能标为「历史未签名」。

### 4. 双轨划界

- 第一轨（工程补齐）脚本：不得写账本、不得写权威源（除 C-3 例外）、不得建 Runtime 构件。
- `health-check.ps1` 与 `verify-system.ps1` 必须**只读**，仅输出 PASS/FAIL，不得触发写入或修复。
- 第二轨（治理地基）在本批次只产出规则与 schema 文档，不产出 Runtime 实现。
- 越轨自检由 `verify-system.ps1` 执行：`.jsonl` 计数、Runtime 目录存在性检查。

### 5. Enforced 四判据

标记 `Enforced` 必须四条同时成立，缺一不可：

1. 规则存在
2. 机制存在
3. 自动阻断存在
4. 绕过测试**全部失败**（无对象时不写测试，写必假 PASS）

`marking_partial_as_enforced` 为**永久禁止项**，非阶段性约束。

---

## 三、裁决优先级

```text
用户逐项裁决  >  本宪法  >  目标架构指令  >  Full-Run-Plan-v2  >  其他 Docs
```

编号沿用目标架构原编号（L92 / A1–A4 / I-1~I-7），不重命名；I-2 / I-3 是否启用待用户确认。

---

## 四、未决事项（不因本宪法而自动生效）

| 项 | 状态 |
| --- | --- |
| I-2 / I-3 是否启用 | 待用户确认 |
| C-4（派发链 vs Broker 入口重叠） | 待用户确认（建议阶段 6 推迟到 Broker 后） |
| C-5（Vault 移 OneDrive） | 待用户确认（建议排在账本 schema 后，执行前后各做全量校验） |
| GOALS.md / RULES.md | 缺失，第二轨第 6 步补齐 |
| TaskStore Schema / 账本 schema / Gate / 不变式定义 | 缺失，第二轨第 2–5 步 |
