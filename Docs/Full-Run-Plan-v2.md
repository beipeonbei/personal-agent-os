# Full-Run-Plan-v2（全量跑通方案 · 强化版）

> 制定依据：`Docs/Codebase-Audit-20261021.md` 的实测审计结论
> 取代此前未落盘的 Full-Run-Plan 思路；本版每阶段明确「现状 → 改进动作 → 改进目标 → 预期效果」
> 范围：Personal-Agent-OS 全量跑通。不含其他项目

## 总纲

审计结论一句话：**分层合理，但库里只有文档和状态，没有可执行、可追溯、已接通的物。**

所以本方案的主线不是继续写文档，而是补齐三类缺失：

| 类别 | 缺什么 | 对应阶段 |
|---|---|---|
| **可执行物** | 脚本（同步/体检/导出/备份/校验）+ 三个占位目录的运行清单 | 阶段 1、2 |
| **可追溯物** | 运行日志、备份 | 阶段 1、3 |
| **已接物件** | MCP 接入、Agent 激活、OneDrive 同步、Office Node、Runtime 接线 | 阶段 4、5、6 |

---

## 阶段 0 · 审计与方案落盘 ✅ 已完成

- **现状**：系统已有 17 份文档、3 份状态 yaml，但从未做过代码库审计
- **动作**：实测扫描全库，识别 12 个薄弱点，逐项给强化建议，重制本方案
- **改进目标**：产出 `Codebase-Audit-20261021.md`（审计）+ 本文件（方案），并写入 system-state.yaml 的 audit 段
- **预期效果**：从"凭印象判断系统状态"转为"有审计基线、有改进目标、可追踪进度"

---

## 阶段 1 · 自律能力补齐（最高优先）

- **现状**：全库零脚本；同步、体检、备份、导出全靠手动（W1/W8/W9/W12）
- **动作**：新建 `Config/scripts/` 五个脚本——`daily-sync.ps1`、`health-check.ps1`、`memory-export.ps1`、`backup-vault.ps1`、`verify-system.ps1`；**脚本一律纯 ASCII 英文注释**（PowerShell 5.1 读取无 BOM 的 UTF-8 中文会乱码，W12）
- **改进目标（可验收）**：
  1. 五个脚本均可独立运行并输出 PASS / FAIL
  2. `health-check.ps1` 一次跑完五维体检（Docker 引擎 / OpenHands 容器 / Canvas / 挂载 / Hermes 进程 + DSH 端口）
  3. `backup-vault.ps1` 一次备份带文件数校验
  4. `verify-system.ps1` 一条命令输出 12 目录 + Config 一致性 + git 干净状态
- **预期效果**：运维从"半小时手动"降到"分钟级自动"；系统首次具备自检与回滚能力；为阶段 5 的目录操作提供安全网
- **依赖**：无
- **回滚**：删除 `Config/scripts/` 目录即可，不影响任何既有组件
- **预计耗时**：1–2 小时

---

## 阶段 2 · 占位目录落真配置

- **现状**：`OpenHands/`（容器真实在跑）、`Hermes/`（真实运行中）、`Harness/`（8080 在线）三个目录各只有一个 README，运行配置散落在 Docs 里，换机不可复现（W6）
- **动作**：
  - `OpenHands/run.ps1`：实际启动命令（镜像 tag、8000 端口、两个挂载、`unless-stopped`）+ 常用变体（8001、常驻、停止）
  - `Hermes/README`：启动入口（开始菜单 Hermes.lnk 真实目标路径）+ 铁律（唯一启动源、禁手动 gateway run）+ 健康检查脚本路径
  - `Harness/README`：启动配方（8080、清代理变量、全局安装入口 `node lib/bin.js`、配方文件缺失标注）
- **改进目标**：三个目录各有一份可照抄执行的运行清单，照着做能起服务
- **预期效果**：运行态与代码库不再脱节；换一台电脑按目录即可复现
- **依赖**：无（可与阶段 1 并行）
- **回滚**：git revert
- **预计耗时**：30 分钟

---

## 阶段 3 · 知识层与日志落地

- **现状**：Vault 六目录中 5 个仅 `.gitkeep`；Logs 零运行日志，但系统已多次真实运行（W2/W3）
- **动作**：
  - 用现有 4 个模板各生成 1 篇真实种子笔记，补进 Inbox / Projects / Research / Startup / Daily
  - 建立运行日志约定：`Logs/YYYY-MM-DD-<topic>.md`，由 `health-check.ps1` 自动追加当日摘要
- **改进目标**：
  1. Vault 五个空目录各有 ≥1 篇真实笔记（非占位文件）
  2. Logs 出现按日归档的真实运行记录
- **预期效果**：Vault 从空壳变可用知识库；故障可追溯；Shared Knowledge 才有内容可共享
- **依赖**：阶段 1（脚本负责自动追加日志）
- **回滚**：删除新增笔记与日志文件，Vault 结构不受影响
- **预计耗时**：1 小时

---

## 阶段 4 · MCP 接入与 Agent Team 激活

- **现状**：MCP 只有计划零接入；roles.yaml 五 Agent 仅 chief 在岗，其余 reserved 且无激活条件（W4/W5）
- **动作**：
  - 接入 2 个零风险 MCP：`filesystem`（只读 Vault/Projects）、`github`（仓库查询），落 `MCP/mcp-filesystem.json`、`MCP/mcp-github.json` 与接线说明；其余 4 个保留计划并标注未接
  - roles.yaml：`coding` 转 active（由 OpenHands 承担）；`research`/`ops` 的 host 由 `tbd` 改为 `hermes`；每个 reserved 补 `activation_condition` 字段
  - `Portal/` 标 `SPEC_FROZEN / NOT_IMPLEMENTED` 并写明触发条件（W7）
- **改进目标**：
  1. ≥2 个 MCP 配置落库且可用
  2. roles.yaml 中 active ≥ 2，所有 reserved 项有激活条件
  3. Portal 状态与触发条件明确
- **预期效果**：MCP 从纸面进入可用；Agent Team 从 1/5 到 2/5；消除 Portal 的状态模糊
- **依赖**：无（可与阶段 2/3 并行）
- **回滚**：删除 MCP 配置、git revert roles.yaml
- **预计耗时**：1–2 小时

---

## 阶段 5 · 双节点接线（OneDrive → Office Node）

- **现状**：Vault 是普通目录（LinkType 空），`OneDrive\Vault` 不存在；Office Node 未部署（W13/双节点未成立）
- **动作**：
  1. **先备份**（阶段 1 的 `backup-vault.ps1`）→ 建 OneDrive junction：Vault 真实内容移入 `OneDrive\Vault`，D 盘路径 junction 回指（磁盘路径不变，Obsidian 与容器挂载无需改）
  2. Office Node 部署（Phase 1.5）：装 Git / VS Code+Copilot / CodeBuddy / Obsidian / OpenHands（Docker 看公司策略）→ clone 仓库 → 双向验证 Vault 与 git
- **改进目标**：
  1. `D:\Personal-Agent-OS\Vault` 为 junction，测试笔记在 OneDrive 云端可见
  2. Office Node 提交在远端可见；两端 Vault 双向同步 5 分钟内可见
  3. Office 端 OpenHands 可用，或已记录降级方案（公司禁 Docker 时）
- **预期效果**：Two Nodes 真正成立；Shared Knowledge / Shared GitOps 从声明变为事实
- **依赖**：阶段 1（备份能力）；**junction 需用户批准**（涉及目录移动）；Office 部署需用户在公司电脑到场
- **回滚**：删 junction 并把 OneDrive 内目录移回 D 盘；Office 移除克隆目录，Home Node 不受影响
- **预计耗时**：junction 15 分钟 + Office 部署半天

---

## 阶段 6 · Runtime 接线（依赖 key）

- **现状**：DSH 8080 在线但 API key 401；不派发、不接任务（W14/Runtime 空槽）
- **动作**：key 就位后按 `Docs/Runtime-Readiness.md` 第四节清单——初始化 `.dsh` profile、补 `dsh.json` 配方（脱敏入库）、打通 Chief → Harness → OpenHands 派发（任务单 → 执行 → 产物落 Projects/ → 日志落 Logs/ → 结论回写 Vault）
- **改进目标**：一次端到端派发成功，三段各有产物与日志
- **预期效果**：Runtime 层从占位变可用；执行链闭合
- **依赖**：**DeepSeek API key 有效（用户动作，涉及费用，AI 不代做）**
- **回滚**：断开派发，回到 Chief 直接调 OpenHands，系统其余部分不受影响
- **预计耗时**：key 就位后 1–2 小时

---

## 阶段 7 · 全量验收与成熟度重算

- **动作**：用阶段 1 的 `verify-system.ps1` + `First-Week-KPI.md` 九项核对 + 六层实际状态复查，重算成熟度，产出 `Docs/Full-Run-Acceptance.md`
- **改进目标**：九项 KPI 逐项给出实测结论；成熟度分数可解释（含分项明细）
- **预期效果**：系统状态可自证，不依赖人工回忆
- **依赖**：阶段 1–6

---

## 成熟度演进预期

| 时点 | 分数 | 变化来源 |
|---|---:|---|
| 当前（Beta 0.9） | 72/100 | 配置固化完成 |
| 阶段 1+2 后 | ~78 | 自律脚本 + 运行清单落库 |
| 阶段 3+4 后 | ~84 | 知识层有内容、MCP 与 Agent 可用 |
| 阶段 5 后 | ~92 | 双节点成立、Shared Knowledge 接通 |
| 阶段 6 后 | ~96 | Runtime 接线闭合 |
| 满分条件 | 100 | 长期稳定运行 + 日常沉淀（W10/W11 持续项） |

---

## 执行顺序与并行关系

```text
阶段0 审计 ✅
   ↓
阶段1 自律脚本 ──── 阶段2 占位目录落真 ──┐
   ↓             ├── 阶段3 知识层与日志 ──┤
                 └── 阶段4 MCP 与 Agent ──┴── 阶段5 双节点接线 ── 阶段7 全量验收
                                              阶段6 Runtime（依赖 key）──┘
```

- 阶段 1 是 2/3/4 的前置（无脚本则无法自动校验与备份）
- 阶段 2/3/4 之间互不阻塞，可连续执行
- 阶段 5 与阶段 6 可并行（一个在办公室、一个等 key）；阶段 5 需你批准与到场
- 阶段 7 依赖前面全部

## 硬约束（贯穿全部阶段）

1. 不新增组件、不装新软件；脚本属"补齐自律能力"（新增文件，非新增组件）
2. 不重新设计六层架构，只做接线与补齐
3. 花钱动作（DeepSeek key）由你执行
4. 诚实纪律：未检测到的写"未复验/受限"，失败保留真实失败，不覆盖成 PASS
5. 每个阶段结束即 `git commit / push`（前缀 `[home]`/`[office]`），保持可回滚
6. 脚本纯 ASCII 注释；YAML/MD 维持 UTF-8

## 下一步

**阶段 1（自律脚本）** 无外部依赖，确认后即可开工。它是其余阶段的执行载体与安全网。
