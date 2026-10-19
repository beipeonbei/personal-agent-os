# DSH-Integration-Report（Phase 3 接入报告）

> 检测时间：2026-10-19 · 全部结论基于本机实测
> 接入方式：复用 DSH-Research 既有部署资产复跑，未重新研究、未重新安装

## 1. DSH 当前状态（三问实测）

| 问题 | 实测结果 |
| --- | --- |
| 是否可启动 | ✅ **可启动且已启动**。自启任务 `DSH-DeepSeekHarness`（State: Ready）；本次用既有配方后台拉起（清代理环境变量 + 全局安装入口 `node lib/bin.js web --port 8080`），启动日志干净（无 error） |
| 是否能连接模型 | ❌ **不能**。`check_dsh_key.py` 实测返回 **401：api key ****04e5 invalid**（DeepSeek 服务端拒绝）。User 环境变量 `DEEPSEEK_API_KEY` 存在但已失效——与 2026-08-25 复盘预判一致（需充值/换 key） |
| 是否能监听端口 | ✅ **是**。http://127.0.0.1:8080 返回 **HTTP 200**（14523B，DeepSeek Harness WebUI） |

## 2. Harness Health Check

| 检查项 | 状态 | 证据 |
| --- | --- | --- |
| 程序本体 | ✅ | `@deepseek-ai/dsh@0.1.1-rc.2` 全局安装（Hermes 自带 node v22），入口 `lib/bin.js` 在位 |
| WebUI 服务 | ✅ | 8080 监听 + HTTP 200 + 启动日志无 error |
| 模型连接 | ❌ | 401 invalid api key（**唯一功能性阻塞，用户动作**） |
| 自启任务 | ✅ | `DSH-DeepSeekHarness` Ready（AtLogOn） |
| 配方文件 | ⚠️ | `dsh.json` **不存在**（复盘提及但文件缺失）；以 launch_dsh.ps1/fix_and_launch.ps1 实际参数为准（端口 8080、清代理、全局入口） |
| 原生模块 | ⚠️ | node-pty/koffi 未构建（历史已知限制）→ 终端类插件受限；WebUI + 模型对话主链路不受影响 |

## 3. 能力面验证（Plugin / Task / SubAgent / Event）

| 能力 | 结论 | 证据 |
| --- | --- | --- |
| Plugin | ✅ 正常 | 架构实证：profile = 插件 bundle 按序叠加（`@deepseek-ai/dsh-base`/`dsh-web-app`/`dsh-headless`）；`dsh plugin --profile <name>` 经 pnpm 管理插件；包内 `lib/plugin-*.js` 与 `config/agent-presets` 在位 |
| Task | 🟡 架构在位、功能待 key | WebUI 的任务界面可达（200），但建任务需模型可用；key 更换后可验证 |
| SubAgent | 🟡 架构在位、功能待 key | `config/agent-presets`（agent 预设）存在；多 agent 编排需 key 后实测 |
| Event | 🟡 架构在位、功能待 key | profile boot/event 机制随 bundle 加载（启动日志显示正常 boot）；事件流消费需 key 后实测 |

> 说明：DSH 为打包/minified 发行，代码级验证受限，以上以"安装资产 + 启动实证 + README 架构描述"三方交叉为准；标 🟡 项在 key 失效期间**不虚构为可用**。

## 4. Chief → Harness → OpenHands 执行链

| 链段 | 状态 | 实测 |
| --- | --- | --- |
| Chief Agent（M365 Copilot） | ✅ 在线 | 公司环境入口，用户侧 |
| Harness（DSH） | ✅ 在线 | 8080 HTTP 200；模型连接待 key |
| OpenHands | ⚠️ 待复验 | 今日早先实测 Up（canvas 200）；本次会话中 Docker Desktop 进程意外停止（0 进程），已重新启动，**容器恢复状态未及复验**（命令审批超时） |

派发流约定（已文档化，待 key 后实测端到端）：
`Chief 写任务单 → Harness 收单调度 → OpenHands（/projects）执行 → 产物落 Projects/ → 日志落 Logs/ → 结论回写 Vault`

## 5. 接入结论

- DSH 作为 Runtime Layer **骨架已接入**：服务在线、自启就绪、插件架构实证
- **唯一功能阻塞：DeepSeek API key 失效（401）**——需阿北充值或换 key（唯一涉及费用的动作，AI 不可代做）
- key 更换后待验证：Task/SubAgent/Event 三项功能 + 端到端执行链
- 另有一项待复验：Docker Desktop 重启后 OpenHands 容器是否自动恢复（`--restart unless-stopped` 策略应生效，未及确认）
