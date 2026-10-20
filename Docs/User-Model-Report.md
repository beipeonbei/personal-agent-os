# User-Model-Report（用户模型完善报告）

> 时间：2026-10-20 · 产出：`Vault/AgentOS/USER.md`（权威版）+ 本报告

## 1. 完善前状态

| 位置 | 内容 | 规模 |
| --- | --- | --- |
| Hermes 侧 `memories/USER.md` | 仅 1 条："需要安装 wxauto 的工具" | 96 B |
| Vault 侧 `AgentOS/USER.md` | **不存在** | — |

用户模型是昨日 Phase 2 审计中唯一的 ⚠️ 项（"偏薄"）。

## 2. 完善后状态

`Vault/AgentOS/USER.md` 已建立，含用户要求的全部小节：

| 小节 | 状态 | 内容来源 |
| --- | --- | --- |
| Identity | ✅ | Hermes SOUL.md 既定主人身份 + 本会话实证（阿北/Bei~、中文、Windows 双节点） |
| 工作背景 | ✅ 部分待补充 | E:\AI work 下的电商工具/信号分析项目、JARVIS→Hermes→Personal Agent OS 演进、手机屏创业构想；任职信息标"待补充" |
| 当前项目 | ✅ | Personal-Agent-OS Beta 0.9 主线 + OpenHands/Hermes 接入 + 电商工具 |
| 长期目标 | ✅ 部分待补充 | One OS/Two Nodes 常态化、Personal Agent Network、AI 创业落地；量化指标标"待补充" |
| 短期目标 | ✅ | Beta 0.9 固化 / Office Node 部署 / 换 key 跑通执行链 / 保持 pull-push 习惯 |
| 工作习惯 | ✅ | 夜间执行、要可执行输出、Phase 式切分、检查表验收、排障四段格式、报错先贴全文 |
| 偏好工具 | ✅ | 十项工具与用途对应表（M365 Copilot / CodeBuddy / VS Code+Copilot / Cursor / Obsidian / Hermes / OpenHands / DSH / GitHub / OneDrive / Docker） |
| 禁忌事项 | ✅ 7 条 | 不讨论排名热度、禁用组件只入附录、不虚构、不擅自花钱、不未确认破坏性操作、不并行提问、不伪造结果 |
| Agent 协作规则 | ✅ 7 条 | 单一入口、Vault 权威、先诊断后动手、一次一个阻塞项、角色分工、提交纪律、报告落盘 |

## 3. 数据一致性处理

- **权威层**：`Vault/AgentOS/USER.md`（新建，Vault 权威规则适用）
- **派生层**：Hermes `memories/USER.md`（旧，96B）——按"冲突 Vault 赢"规则，应回指 Vault 版本；**当前未自动改写**（改 Hermes 记忆文件属其数据面，需用户在 Hermes 侧确认或下次接入时对齐）
- 未知字段一律标「待补充」，未虚构

## 4. 缺口清单

| 缺口 | 影响 | 建议补齐方式 |
| --- | --- | --- |
| Hermes 侧 USER.md 仍是旧版 | 两套用户模型并存，理论上违反 Vault 权威规则 | 用户在 Hermes 中确认，或在后续接入步骤里把 Vault 版内容写入 Hermes `memories/USER.md` |
| 任职/公司信息缺失 | 工作背景不完整 | 用户口述补充 |
| 长期目标无量化指标 | 目标无法验收 | 用户给出量化口径 |
| 固定作息/时间窗未记录 | 排期依赖"今晚/明天"口头节奏 | 用户给出常规可用时段 |
| memory-export 无自动导出 | 记忆回流 Vault 目前靠手动 | 待 DSH/Hermes 稳定后建立定时导出 |

## 5. 结论

用户模型已从"薄弱（96B 单条）"升级为"结构化九节"，可作为 Agent 协作的行为依据。剩余缺口均为**用户侧输入类**缺口（需本人提供或确认），非技术阻塞；其中"Hermes 侧 USER.md 回指"是配置闭环的最后一步，标记为待办而非阻塞。
