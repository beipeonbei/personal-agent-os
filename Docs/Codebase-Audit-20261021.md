# Codebase-Audit（代码库审计 · 2026-10-21）

> 范围：Personal-Agent-OS（`D:\Personal-Agent-OS` + 仓库 `personal-agent-os`）
> 方法：只读实测（目录统计、文件内容、git 状态），不改动任何文件
> 目的：识别覆盖不足 / 结构薄弱 / 改进空间，逐项给强化建议

## 一、代码库体量实测

| 目录 | 文件数 | 体积 | 实质内容判断 |
|---|---:|---:|---|
| Docs | 17 | 121 KB | ✅ 最充实：总体方案 + 5 份 runbook + 5 份接入/审计报告 + 索引 |
| Projects | 2 | 15.9 KB | ⚠️ 仅 README + 1 份 OpenHands 生成的状态报告 |
| Vault | 13 | 9.5 KB | ⚠️ 六目录中 5 个仅 `.gitkeep`；实质内容仅 identity.md / USER.md / 4 模板 |
| Config | 4 | 6.5 KB | ✅ 3 个状态 yaml + README |
| Agents | 3 | 4.9 KB | ⚠️ roles.yaml（1 active / 4 reserved）+ schema + README |
| Prompts | 2 | 2.7 KB | ✅ system-prompts.md + README |
| Portal | 2 | 2.7 KB | 🟡 仅规格（portal-mvp.md），零源码（已知 Phase 2） |
| MCP | 2 | 2.5 KB | ❌ 仅计划，零实际接入 |
| Hermes | 1 | 1.5 KB | ⚠️ 仅 README 占位 |
| Harness | 1 | 1.4 KB | ⚠️ 仅 README 占位 |
| OpenHands | 1 | 1.2 KB | ⚠️ 仅 README 占位，**运行配置未落库** |
| Logs | 1 | 0.7 KB | ❌ 仅 README，零运行日志 |
| 根 | 2 | 2.5 KB | README.md + .gitignore |

提交历史：**7 次**，全部集中在 2026-10-17 ~ 10-20。

## 二、薄弱点清单

### A. 覆盖不足（该有内容但实际为空）

| 编号 | 薄弱点 | 实测证据 | 影响 |
|---|---|---|---|
| **W1** | **零自动化脚本** | 全库脚本类文件仅有 4 个 YAML；**无任何 `.ps1` / `.py` / `.sh` / `.bat`** | 同步、备份、健康检查、记忆导出、每日 pull/push 全靠手动；系统"自律"完全依赖人的纪律 |
| **W2** | **Vault 六目录是空壳** | Inbox / Projects / Research / Startup / Daily 各仅一个 `.gitkeep`（108B），零真实笔记 | 知识层"有结构无内容"；Obsidian 打开是空的；Shared Knowledge 无内容可共享 |
| **W3** | **Logs 零运行日志** | Logs/ 只有 README；但系统已真实运行多次（OpenHands 任务、Docker 故障恢复、Hermes 启动、多次健康检查） | 故障不可追溯，状态不可回看 |
| **W11** | **Projects 近乎空** | 仅 README + 一份 OpenHands 生成的状态报告 | 执行层产出没有归宿目录 |

### B. 结构薄弱（声明了但没接通）

| 编号 | 薄弱点 | 实测证据 | 影响 |
|---|---|---|---|
| **W4** | **MCP 只有计划零接入** | MCP/ 仅 mcp-plan.md + README；无任何 `mcp-*.json`；计划列 6 个服务（filesystem/github/obsidian/browser/email/calendar）一个未接 | Agent 无外部工具能力，MCP 层是纸面层 |
| **W5** | **Agent Team 仅 1/5 在岗** | roles.yaml：chief=active；research(host=tbd)/coding(host=openhands)/browser(host=openhands)/ops(host=tbd) 均 reserved，且**无激活条件字段** | 多 Agent 协作不成立；reserved 项是空占位而非"待激活" |
| **W6** | **占位目录无实质配置** | Hermes/、Harness/、OpenHands/ 各仅 README；OpenHands 虽真实运行（容器 Up、Canvas 200、挂载 `D:\Personal-Agent-OS:/projects`），但**启动命令与挂载清单未落库** | 运行态与代码库脱节；换机不可复现；信息散落在 Docs 里 |

### C. 改进空间（有基础但可加强）

| 编号 | 薄弱点 | 实测证据 | 影响 |
|---|---|---|---|
| **W7** | **Portal 状态模糊** | 只有 portal-mvp.md，无源码也未写明"暂不实现"与触发条件 | 看起来在计划中，实际不实现，状态含糊 |
| **W8** | **无验证 / 测试 / CI** | 无测试脚本、无 CI、无 git hook | 系统一致性全靠每次手动实测，状态不可自证 |
| **W9** | **无备份机制** | 库内无备份脚本、无备份目录 | 做 OneDrive junction（涉及目录移动）前没有回滚能力 |
| **W10** | **运行沉淀极浅** | 提交仅 7 次，集中 4 天内 | 系统仍是"新建"而非"在跑" |
| **W12** | **PowerShell 5.1 中文编码隐患** | `.gitignore` 含中文注释，在 PowerShell 5.1 默认读取下显示乱码（无 BOM 的 UTF-8 被按 GBK 解析） | **待建的 `.ps1` 脚本若含中文注释会乱码甚至报错**，必须先定编码规则 |

## 三、逐项强化建议（现状 → 动作 → 目标 → 预期效果）

### W1 — 补自动化脚本（最高优先）

- **动作**：在 `Config/scripts/` 下新增五个脚本（新增文件，非新增组件）：
  - `daily-sync.ps1`：git pull → 冲突检查 → add/commit/push（提交前缀按节点）
  - `health-check.ps1`：五维体检（Docker 引擎 / OpenHands 容器 / Canvas / 挂载 / Hermes 进程 + DSH 端口）
  - `memory-export.ps1`：Hermes `MEMORY.md`+`USER.md` 快照写入 `Vault/AgentOS/memory-export/YYYY-MM-DD.md`，带哈希与来源标注
  - `backup-vault.ps1`：Vault 带日期戳备份 + 文件数校验
  - `verify-system.ps1`：校验 12 目录存在、Config 与实测一致、git 工作区干净
- **目标（可验收）**：五个脚本均可独立运行并输出 PASS/FAIL；`health-check` 每日一次可无人值守
- **预期效果**：系统从"全手动"变为"可自跑"，日常运维从半小时降到分钟级；同时解决 W8（一键体检）与 W9（备份能力）

### W2 — Vault 知识层填充

- **动作**：用现有 4 个模板各生成 1 篇真实种子笔记，补到 Inbox/Projects/Research/Startup/Daily；每次系统运行结论按日归档
- **目标**：Vault 五个空目录各有至少 1 篇真实笔记（非占位文件）
- **预期效果**：Vault 从空壳变为可用知识库；Obsidian 打开即有内容；Shared Knowledge 才有东西可共享

### W3 — 运行日志约定

- **动作**：约定每次健康检查 / 部署 / 故障写 `Logs/YYYY-MM-DD-<topic>.md`，由 `health-check.ps1` 自动追加当日摘要
- **目标**：Logs 出现按日归档的真实运行记录（≥1 篇/次运行）
- **预期效果**：故障可追溯、状态可回看；配合 W10 形成运行沉淀

### W4 — MCP 先接两个零风险服务

- **动作**：接入 `filesystem`（只读 Vault/Projects）与 `github`（仓库查询），落 `MCP/mcp-filesystem.json`、`MCP/mcp-github.json` 与接线说明；其余 4 个保留计划并标注未接
- **目标**：至少 2 个 MCP 配置落库且可用
- **预期效果**：MCP 从计划层进入可用层，Agent 获得文件与仓库工具

### W5 — Agent Team 激活与条件化

- **动作**：`coding` 转 active（由 OpenHands 实际承担）；`research`/`ops` 的 host 由 `tbd` 改为明确承载（`hermes`，待 Phase 2）；每个 reserved 项补 `activation_condition` 字段
- **目标**：roles.yaml 中 active ≥ 2，所有 reserved 项均有激活条件
- **预期效果**：Agent Team 从 1/5 到 2/5，预留项从空占位变成"有触发条件的状态"

### W6 — 占位目录落真配置

- **动作**：`OpenHands/` 补 `run.ps1`（实际启动命令、端口、挂载、重启策略）；`Hermes/` 补启动入口与铁律（Hermes.lnk 路径、禁手动 gateway run）；`Harness/` 补启动配方（8080、清代理、全局入口，标注 dsh.json 缺失）
- **目标**：三个目录各有一份"可照抄执行"的运行清单
- **预期效果**：运行态与代码库不再脱节；换机可复现

### W7 — Portal 状态冻结并写明触发条件

- **动作**：README 写明 `SPEC_FROZEN / NOT_IMPLEMENTED`，触发条件（如 Office Node 上线且双节点稳定后）
- **目标**：Portal 状态与触发条件明确
- **预期效果**：消除"未实现但看起来在计划中"的模糊

### W10 — 运行沉淀

- **动作**：靠 W1 的 daily-sync 与 W3 的日志自动产生提交与记录
- **目标**：形成每日 pull/push + 日志的日常节奏
- **预期效果**：系统从"新建"转为"在跑"

### W11 — 产出物归档

- **动作**：每次 OpenHands / Agent 产物落 `Projects/<topic>/`，并回写 Vault 结论
- **目标**：Projects 出现按主题归档的产物
- **预期效果**：执行层产出有固定归宿

### W12 — 编码规则（W1 的前置）

- **动作**：定死规则——所有 `.ps1` 脚本**纯 ASCII 英文注释**（PowerShell 5.1 按 GBK 读无 BOM 的 UTF-8 会乱码）；需要中文时用带 BOM 的 UTF-8；YAML/MD 维持 UTF-8 无 BOM（git 与 Obsidian 读取正常）
- **目标**：五个脚本在 PowerShell 5.1 下运行与显示均正常
- **预期效果**：避免自建脚本因编码问题不可用

## 四、优先级排序

| 顺序 | 编号 | 理由 | 成本 |
|---|---|---|---|
| 1 | W12 + W1 | 脚本是其余所有改进的执行载体，编码错了脚本直接废 | 约 1 小时 |
| 2 | W9（含在 W1） | OneDrive junction 前必须有回滚能力 | 随 W1 |
| 3 | W6 | 三目录落真配置，成本低、立刻消除脱节 | 约 30 分钟 |
| 4 | W3 + W2 | 日志与知识内容，让系统有"记忆" | 约 1 小时 |
| 5 | W4 + W5 | MCP 与 Agent 激活，中成本 | 约 1–2 小时 |
| 6 | W7 | 状态标注，纯文档 | 10 分钟 |
| 7 | W10 + W11 | 靠日常运行自然沉淀 | 持续 |

## 五、审计结论

**分层设计是合理的，问题在于"库里只有文档和状态，没有可执行的物"。**

17 份文档把系统描述得很完整，但代码库里没有一个能自己跑起来的脚本、没有一个真实日志、没有一个真正接上的 MCP、五个 Agent 里只活了一个、Vault 六个目录五个是空的。系统目前的运转完全依赖人手动执行文档里的步骤。

优先补齐"可执行物"（脚本）、"可追溯物"（日志/备份）、"已接物件"（MCP/活跃 Agent）三类，是让系统从"被描述"走向"在运转"的最短路径。
