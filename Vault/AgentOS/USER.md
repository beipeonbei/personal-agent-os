# USER.md（用户模型 · 权威版）

> 本文件是 Personal Agent OS 的 **User Model 权威源**，Vault 权威规则适用于它。
> Hermes 侧 `AppData\Local\hermes\memories\USER.md` 为派生层，冲突以本文件为准。
> 建立：2026-10-20（Phase Beta 0.9 配置固化）
> 内容原则：只写已实证事实；未确认字段标「待补充」，不虚构。

## Identity

- 称呼：阿北（Bei~）
- 语言：简体中文（回复一律中文）
- 环境：Windows 11 + PowerShell；Home Node（家里电脑）与 Office Node（公司电脑）双节点
- 在 Hermes 侧身份体系中的定位：JARVIS 服务的唯一主人（SOUL.md 既定）
- 角色自述（外部观察）：AI 创业研究者 + 知识工作者 + 产品经理 + 开发者

## 工作背景

- 长期在本机构建本地 AI Agent 体系：JARVIS → Hermes 桌面端（v0.21.7）→ Personal Agent OS
- 有电商方向的数据采集/分析实践（E:\AI work 下的淘宝、抖音相关爬虫与工具）
- 有信号分析与方法论沉淀实践（signal-integrity、lottery-selector、DSH-Research 等独立项目）
- 有手机屏供应链相关的创业构想与资源对接（顺德容桂天猫新电商方向）
- 具体任职/公司信息：**待补充**

## 当前项目

1. **Personal-Agent-OS**（主线）：双节点个人 Agent 系统，当前 Beta 0.9，Phase 1.5（Office Node）待执行，Phase 3（DSH Runtime）卡在 API key
2. **OpenHands 接入**：已作为执行中心运行（/projects = D:\Personal-Agent-OS）
3. **Hermes Memory 接管**：已完成，四要素有实证
4. **电商数据与创业工具**：持续进行（E:\AI work）
5. 其他并行项目规模较大，明细见 `Projects/` 与各独立工作区

## 长期目标

- One Personal Agent OS / Two Nodes 常态化运转：知识、配置、GitOps、记忆四层共享
- 个人 Agent 网络（Personal Agent Network）：两台电脑都是同一 Agent 网络的节点
- AI 创业方向落地：把方法论资产转化为实际业务
- 具体量化目标：**待补充**

## 短期目标

- 完成 Beta 0.9 系统配置固化（system-state / USER.md / 三份审计报告）
- 部署 Office Node（Phase 1.5，24 小时目标）
- 更换 DeepSeek API key 后跑通 Chief → Harness → OpenHands 执行链
- 保持每日 `git pull / push` 与单一入口习惯

## 工作习惯

- **夜间执行**：典型节奏是"今晚做 Home Node、明天做 Office Node"
- **要可直接执行的输出**：命令、步骤、验收标准，不要理论铺垫
- **分阶段推进**：Phase 1.5 / 2 / 3 式切分，每阶段要求验收标准
- **用检查表验收**：偏好勾选式清单（□ Docker 正常 / □ Git 正常 …）
- **遇问题要排障格式**：问题 → 原因 → 解决命令 → 验证命令
- **报错先贴完整输出**：明确要求"看到结果前不要推测、不要重装/重启"
- **决策快但边界硬**：自己拍板组件取舍、花钱类动作自己来

## 偏好工具

| 用途 | 工具 |
| --- | --- |
| 主脑 / 日常入口（公司） | M365 Copilot |
| 实施工程师 / IDE 会话 | CodeBuddy |
| 编码主环境 | VS Code + GitHub Copilot |
| 备用编码界面 | Cursor |
| 知识库 / 记忆权威源 | Obsidian |
| 常驻大脑 / Memory 管理 | Hermes 桌面端 |
| Agent 执行中心 | OpenHands |
| Runtime（待 key） | DeepSeek Harness |
| 版本与配置同步 | GitHub |
| 知识同步 | OneDrive |
| 容器底座 | Docker Desktop + WSL2 |

## 禁忌事项

1. **不讨论** Star 数、工具排名、热度、行业趋势
2. **不在实施步骤中出现** Claude Code / OpenAI Codex / Grok（环境不可用，只允许出现在附录）
3. **不虚构**：未检测到的能力写"未复验/受限"，不许写成可用；未确认的用户信息标"待补充"
4. **不擅自花钱**：API key 充值 / 换 key 类动作由用户本人决定
5. **不做未确认的破坏性操作**：重装、重启、重建 WSL 等需先拿到诊断证据
6. **不并行提问**：入口只有 M365 Copilot 一个，不同时问多个工具
7. **不伪造结果**：诚实上报命中率/状态，合成数据须标注

## Agent 协作规则

1. **单一入口**：日常入口 = M365 Copilot（Chief），其余工具是被调度的执行者
2. **Vault 权威**：Identity / 知识 / 结论以 Vault 为准；冲突时 Vault 赢，派生层当天对齐
3. **先诊断后动手**：拿到实际输出再分析，禁止先给重装/重启建议
4. **一次一个阻塞项**：每轮只解决当前阻塞，不展开后续阶段
5. **角色分工**：用户 = 现场架构师（决策 + GUI/花钱动作）；CodeBuddy = 实施工程师（执行 + 排障 + 出报告）
6. **提交纪律**：`git add/commit/push`，信息带节点前缀 `[home]` / `[office]`
7. **报告落盘**：每次接入/审计/健康检查产出 Markdown 报告入 `Docs/`，随仓库同步

## 待补充字段

- 具体任职与公司信息
- 长期目标的量化指标
- 固定作息与可用时间窗（当前仅知夜间执行倾向）
- 团队协作/对外沟通偏好
