# Integration-Plans（Office Node + Hermes + DeepSeek Harness 接入规划）

> 定位：基于现有 Personal-Agent-OS 的接入执行计划，不重新设计系统。
> 每阶段固定六段：安装步骤 / 配置步骤 / 同步步骤 / 验收标准 / 风险项 / 回滚方案。
> 事实基线（2026-10-18 实测）：Home Node 已就绪（Docker 29.8.2 / OpenHands / git 同步）；Hermes v0.21.7 已装于 Home Node（未运行）；DSH 有 2026-08-25 跑通资产（WebUI 8080 / 自启任务 / dsh.json 配方）。
> 执行顺序：Phase 1.5 → Phase 2 → Phase 3。Phase 2/3 只落 Home Node，Office Node 经同步层只读受益。

---

# Phase 1.5 · Office Node Deployment Plan

**目标**：24 小时内在公司电脑上线第二节点，与 Home Node 构成 One OS / Two Nodes。

## 安装步骤

按序安装（清单依据 `Software-Inventory.md` Office 段）：

| # | 软件 | 获取 | 验收命令 |
| --- | --- | --- | --- |
| 1 | Git | https://git-scm.com/download/win | `git --version` |
| 2 | VS Code + GitHub Copilot 扩展 | https://code.visualstudio.com/ | `code --version` |
| 3 | CodeBuddy | https://www.codebuddy.ai/ | `codebuddy` 可执行 |
| 4 | Obsidian | https://obsidian.md/download | 能启动 |
| 5 | Docker Desktop（公司策略允许才装） | https://www.docker.com/products/docker-desktop/ | `docker version` 有 Server 段 |
| 6 | OpenHands（依赖 5） | 见下方配置步骤 | localhost:8000/canvas 返回 200 |
| 7 | Cursor（可选） | https://cursor.com/download | 能启动 |

## 配置步骤

1. Git 身份：
```powershell
git config --global user.name 'beipeonbei'
git config --global user.email '1321386862@qq.com'
```
2. OneDrive 登录（**必须与 Home Node 同一微软账号**，否则 Vault 不通）。
3. 克隆仓库：
```powershell
git clone https://github.com/beipeonbei/personal-agent-os.git D:\Personal-Agent-OS
```
4. OpenHands 启动（**用修正后的挂载**，与 Home Node 完全一致）：
```powershell
New-Item -ItemType Directory -Force -Path 'D:\Personal-Agent-OS\Projects', "$env:USERPROFILE\.openhands" | Out-Null
docker run -d --restart unless-stopped -p 127.0.0.1:8000:8000 `
  -e AGENT_CANVAS_ALLOW_LAN_SESSION_KEY=true `
  -v "$env:USERPROFILE\.openhands:/home/openhands/.openhands" `
  -v 'D:\Personal-Agent-OS:/projects' `
  --name openhands ghcr.io/openhands/agent-canvas:1.27.1
```
5. Obsidian：Open folder as vault → `D:\Personal-Agent-OS\Vault`（六目录 + 模板随 OneDrive 到位）。
6. 节点标识已由 `Config/office-node.yaml` 承担，无需额外配置。

## 同步步骤

| 资产 | 通道 | 操作 |
| --- | --- | --- |
| Vault | OneDrive | 自动；建测试笔记双向验证 |
| 配置/文档/Agent 定义 | GitHub | 每日 pull/push，提交前缀 `[office]` |
| OpenHands 状态 | 本地 | `.openhands` 卷本节点独立，不同步 |

同步纪律：开工先 `git pull`，收工 `git push`；禁止 force push。

## 验收标准

- [ ] `git log --oneline` 能看到 Home Node 的全部提交（init / docs / runbook 等）
- [ ] Office 端 `git push` 一次，Home 端 `git pull` 可见
- [ ] Office 的 Vault 新建笔记，Home 端 5 分钟内可见（反之亦然）
- [ ] OpenHands（装了的话）：http://localhost:8000/canvas 返回 200，容器内 `ls /projects` 见 12 目录
- [ ] `Config/office-node.yaml` 与磁盘实际组件一致

## 风险项

| 风险 | 现象 | 处置 |
| --- | --- | --- |
| 公司策略禁装 Docker | OpenHands 无法在 Office 跑 | 编码走 VS Code + Copilot + CodeBuddy；Agent 执行任务留在 Home Node 发起，Office 只做开发与验收 |
| OneDrive 账号不一致 | Vault 双边不通 | 必须登录同一微软账号；不一致时 Office 端 Vault 仅本地可用并记录 |
| 杀毒软件拦截 | git/docker 安装异常 | 加白名单或找 IT；装不了 Docker 同上一条降级 |
| 8000 端口被占 | OpenHands 起不来 | 改 `-p 127.0.0.1:8001:8000`，访问 8001 |
| M365 Copilot 登录态 | 入口不可用 | 用公司账号登录 Microsoft 365 |

## 回滚方案

1. 停 OpenHands 容器：`docker stop openhands; docker rm openhands`
2. 删除克隆目录 `D:\Personal-Agent-OS`（GitHub 仓库是权威源，随时可重新 clone）
3. 按安装清单反向卸载
4. Home Node 不受任何影响；双节点同步自然回到单节点状态

---

# Phase 2 · Hermes Integration Plan（接管 Memory Layer）

**目标**：Hermes 成为 Memory Layer 的常驻管理者；Vault 仍是知识权威源。**Hermes 只部署 Home Node。**

## 安装步骤

Hermes v0.21.7 已装于 Home Node，**不从零安装**。步骤为复验与启用：

1. 版本复验：
```powershell
& 'C:\Users\Administrator\AppData\Local\hermes\bin\hermes.exe' --version
```
2. 版本决策：检测到有可用更新（`hermes update`）。**建议先不更新**——等 Memory 接管稳定运行一周后再升，避免升级打断接入验证。
3. 启动（**唯一合法启动源 = 桌面端 Hermes.exe 自拉；禁止手动 `gateway run`**，双入口=双老板互杀）：
```powershell
Start-Process 'C:\Users\Administrator\AppData\Local\hermes\Hermes.exe'
```
4. 健康检查（Hermes-Guide 工具链）：
```powershell
powershell -ExecutionPolicy Bypass -File 'E:\AI work\Hermes-Guide\tools\health_check.ps1
```
5. 挂启动守护（开机自启 + 掉线自愈，仍走桌面端自拉）：
```powershell
powershell -ExecutionPolicy Bypass -File 'E:\AI work\Hermes-Guide\tools\ensure_hermes.ps1'
```

## 配置步骤

1. 本地改动保护：确认 config.yaml 的 `non_interactive_local_changes: keep`（防升级/重启覆盖本地配置）。
2. 记忆分流规则（核心配置，落 `Config/home-node.yaml` 与 `Vault/AgentOS/README` 各记一份）：
   - Hermes 长期记忆 **导出**为 Markdown，落 `Vault/AgentOS/memory-export/YYYY-MM-DD.md`
   - Identity（原则/边界）以 `Vault/AgentOS/identity.md` 为权威，Hermes 侧对齐
   - 知识/笔记仍由人经 Obsidian 直接写；Hermes 不直接改写 Vault 知识区
3. 配置备份（备份到本地，**不进仓库**，config 含密钥）：
```powershell
powershell -ExecutionPolicy Bypass -File 'E:\AI work\Hermes-Guide\tools\backup_config.ps1'
```
4. 节点配置更新：`Config/home-node.yaml` 的 `components.hermes` 从 `not_installed` 改 `ready`，并登记 memory-export 路径。

## 同步步骤

| 数据 | 方向 | 通道 |
| --- | --- | --- |
| Hermes 记忆导出 | Hermes → `Vault/AgentOS/memory-export/` | 本地文件写入 |
| Vault 全树 | Home ↔ Office | OneDrive |
| Hermes 配置 | 本地备份 | backup_config.ps1 → 本地（禁入仓） |

**权威规则**：知识以 Vault 为权威源；Hermes 记忆是派生层。两边冲突时 Vault 赢，Hermes 侧修正。

## 验收标准

- [ ] Hermes 桌面端常驻运行，health_check 全绿，连续 7 天无"双老板"现象（只有一个 gateway）
- [ ] `Vault/AgentOS/memory-export/` 每日有导出文件，Office 端 5 分钟内可见
- [ ] Identity 原则在 Hermes 与 `Vault/AgentOS/identity.md` 之间一致
- [ ] Chief（M365 Copilot）与 Hermes 分工成文：Hermes 答"是什么/为什么"，Chief 派"做什么/怎么做"

## 风险项

| 风险 | 现象 | 处置 |
| --- | --- | --- |
| 双老板互杀 | gateway 反复重启、banner 涨 connected 不涨 | 只留桌面端一个启动源；杀掉的第二个入口永不手动拉起 |
| 升级覆盖本地配置 | 改过的 config 还原 | `keep` 保护 + 每次改配置前跑 backup_config.ps1 |
| 双记忆源分叉 | Hermes 记忆与 Vault 结论不一致 | 按权威规则处理：Vault 赢；当天对齐 |
| 自启任务打架 | Hermes 与 DSH（Phase 3）都抢 AtLogOn | 错峰：Hermes 登录即起，DSH 延迟 60 秒（Phase 3 配置时处理） |

## 回滚方案

1. 关闭 Hermes 桌面端，移除 ensure_hermes 自启任务
2. `Config/home-node.yaml` 的 hermes 状态改回 `not_installed`（或删该行）
3. 删除 `Vault/AgentOS/memory-export/`（如内容不可用）
4. 系统回到 Obsidian 单源记忆，Phase 1 状态完全不受影响

---

# Phase 3 · DeepSeek Harness Integration Plan（接管 Runtime Layer）

**目标**：DSH 成为 Runtime 层（任务调度/派发）；OpenHands 仍是执行中心。**只部署 Home Node。**

## 安装步骤

DSH 于 2026-08-25 已真实跑通，**复用既有资产，不重新部署**：

1. 复验既有部署状态：
```powershell
Test-Path 'E:\AI work\DSH-Research\dsh_ready.flag'
Get-ScheduledTask -TaskName 'DSH-DeepSeekHarness' -ErrorAction SilentlyContinue | Select-Object TaskName,State
```
2. 未运行则用既有修复器拉起（已含全部绕坑：全局安装绕 npx 卡死、`--maxsockets=1` 绕 Clash 并发拦截、`node lib/bin.js` 绕 bin 链接、端口 8080 绕 3080 占用）：
```powershell
powershell -ExecutionPolicy Bypass -File 'E:\AI work\DSH-Research\fix_and_launch.ps1'
```
3. WebUI 复验：浏览器开 http://127.0.0.1:8080 ，期望 200。
4. **API Key 复核（用户动作，涉及费用）**：
```powershell
python 'E:\AI work\DSH-Research\check_dsh_key.py'
```
返回模型列表（deepseek-v4-flash / deepseek-v4-pro）= 有效；无效需充值或换 key（只有你能做）。

## 配置步骤

1. 接口契约登记（`Harness/README.md` 已有预留，Phase 3 落成真）：
   - `task.submit`：接收 Chief 派发的任务单
   - `agent.dispatch`：向 OpenHands 容器派发执行
   - `task.status` / `event.stream`：状态与事件（Portal 预留消费）
2. 派发流定型（写入 `Agents/roles.yaml` 的 runtime 段）：
   `Chief（M365 Copilot）写任务单 → Harness/README 约定目录收单 → DSH 调度 → OpenHands（/projects）执行 → 产物落 Projects/ → 日志落 Logs/ → 结论回写 Vault`
3. 角色激活：`Agents/roles.yaml` 中 reserved 状态的 Coding/Ops Agent，host 指向 harness+openhands 组合，先各试跑一次。
4. 端口固定 8080，登记进 `Config/home-node.yaml`（components.deepseek_harness: ready，port 8080）。
5. 配方入库（脱敏）：`DSH-Research/dsh.json` 复制为 `Harness/dsh.json`，**剔除 key 字段**后提交仓库。
6. 自启错峰：把 `DSH-DeepSeekHarness` 计划任务加 60 秒延迟，避让 Hermes 登录启动。

## 同步步骤

| 资产 | 通道 | 说明 |
| --- | --- | --- |
| `Harness/`（接口+脱敏配方） | GitHub | 随仓库同步 |
| `Agents/roles.yaml` runtime 段 | GitHub | 双节点一致 |
| 任务单与执行记录 | 本地 `Logs/` | 不同步 |
| DSH 程序本体 | 本地 | Office Node 不装 |

## 验收标准

- [ ] http://127.0.0.1:8080 返回 200；`DSH-DeepSeekHarness` 任务状态 Ready
- [ ] `check_dsh_key.py` 返回有效模型列表
- [ ] 端到端一次：Chief 下任务单 → DSH 调度 → OpenHands 在 `/projects` 执行 → 产物落 `Projects/` → 记录落 `Logs/` → 结论回写 `Vault/`
- [ ] 连续 3 天稳定，无端口冲突、无代理拦截复发

## 风险项

| 风险 | 现象 | 处置 |
| --- | --- | --- |
| API key 失效 | check 报 402/空列表 | 充值或换 key（用户动作）；key 失效期间 Phase 3 挂起，Phase 1/2 不受影响 |
| 8080 被占 | WebUI 打不开 | `netstat -ano \| findstr :8080` 找占用方；改端口需同步改 launch 脚本与 Config |
| Clash 代理拦截 | npm/模型 API 连接重置 | 安装用 `--maxsockets=1`；模型调用走直连或确认代理规则放行 |
| 原生模块缺失 | node-pty/koffi 未构建，终端类插件报错 | 已知限制：只用 WebUI + 模型对话主链路，不依赖终端插件 |
| 升级破坏配方 | dsh.json 失效 | 配方在仓库有版本记录，回滚到上一提交 |

## 回滚方案

1. 停任务：`Stop-ScheduledTask -TaskName 'DSH-DeepSeekHarness'`；需要时 `Disable-ScheduledTask`
2. 停 8080 监听：结束 dsh 相关进程
3. `Agents/roles.yaml` 删除 runtime 段（或 git 回滚该提交），`Config/home-node.yaml` 的 deepseek_harness 改回 `not_installed`
4. 系统回到"Chief 直接派发 OpenHands"模式，Phase 1/2 完全不受影响

---

## 附：三阶段依赖关系

```
Phase 1.5 Office Node ──┐
                        ├─→ Phase 2 Hermes（Memory）──→ Phase 3 DSH（Runtime）
Phase 1 Home Node ✅────┘
```

- Phase 1.5 与 Phase 2 可并行（一个在 Office 电脑操作，一个在 Home 电脑操作）
- Phase 3 依赖 Phase 2 的稳定运行（自启错峰、记忆回写链路）
- 任何阶段回滚都不影响已完成阶段
