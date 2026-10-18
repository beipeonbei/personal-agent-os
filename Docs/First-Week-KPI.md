# First-Week-KPI（第一周成功标准）

> 用途：一周后用什么标准判定"Personal Agent OS 双节点基础环境"真的建成了。
> 用法：每天做完当天项就打勾；周末对照总检查表复盘。
> 本周目标：One Personal Agent OS / Two Nodes / Shared Knowledge / Shared GitOps（Hermes 与 DeepSeek Harness 为 Phase 2，不计入本周 KPI）。

## 每日时间线

| 天 | 节点 | 内容 | 依据文档 |
| --- | --- | --- | --- |
| Day 1 | Home | 安装 runbook 八步全流程 | Tonight-Install-Checklist.md |
| Day 2 | Office | 复刻五步 + 双端对验 | Day1-Execution-Pack.md 第二部分 |
| Day 3 | 双端 | 同步演练日：Vault 笔记 + Git 提交各跑 3 轮 | 本文件 A/B 组 |
| Day 4 | Home | Agent 任务日：OpenHands 完整任务一次 | 本文件 C 组 |
| Day 5 | Office | Agent 任务日：Office 端再跑一次 | 本文件 C 组 |
| Day 6 | 双端 | 习惯固化：入口唯一 + 每日 pull/push | 本文件 D 组 |
| Day 7 | — | 总复盘：对照总检查表 | 总检查表 |

## A 组：环境就绪

- [ ] Home Node 目录结构与标准树一致（12 个目录）
- [ ] Office Node 目录结构与标准树一致（12 个目录）
- [ ] Home Node：VS Code + GitHub Copilot 可工作（能补全）
- [ ] Office Node：VS Code + GitHub Copilot 可工作（能补全）
- [ ] Home Node：CodeBuddy 可工作
- [ ] Office Node：CodeBuddy 可工作
- [ ] Home Node：OpenHands 启动成功（http://localhost:8000/canvas 可打开）
- [ ] Office Node：OpenHands 启动成功（或已装待 Docker 策略放行）

## B 组：同步体系

- [ ] Obsidian 同步成功：Home 建一篇笔记，Office 端 5 分钟内可见（反之亦然）
- [ ] GitHub 仓库可推送：两端各完成一次 `git push`，对端 `git pull` 可见
- [ ] 两台电脑目录一致：任一端跑目录比对，结果与标准树相同
- [ ] 无 OneDrive 冲突副本遗留（有则当天合并删除）
- [ ] `Logs/` 未被提交进仓库（`git ls-files Logs/` 为空）

## C 组：Agent 执行

- [ ] 一次完整 Agent 任务执行成功，定义如下五步全走完：
  1. Chief（M365 Copilot）写下任务单（目标/范围/验收标准）
  2. 任务单落 `OpenHands/tasks/`
  3. OpenHands 在 `/projects`（即 `D:\Personal-Agent-OS\Projects`）执行
  4. 产物落在 `Projects/` 指定子目录，执行记录落 `Logs/`
  5. 结果回写 `Vault/`（复盘或结论）
- [ ] Home 与 Office 各完成至少一次上述完整任务

## D 组：日常习惯

- [ ] 每天开工先 `git pull`、收工 `git push` 连续执行 5 个工作日
- [ ] 日常提问只走 M365 Copilot 一个入口，没有多头并行提问
- [ ] 提交信息均带节点前缀（`[home]` / `[office]`）

## 总检查表（周末复盘用）

| # | 标准 | 状态 |
| --- | --- | --- |
| 1 | 两台电脑目录一致 | ☐ |
| 2 | Obsidian 同步成功 | ☐ |
| 3 | GitHub 仓库可推送 | ☐ |
| 4 | OpenHands 运行成功（两端） | ☐ |
| 5 | VS Code + Copilot 可工作（两端） | ☐ |
| 6 | CodeBuddy 可工作（两端） | ☐ |
| 7 | 一次完整 Agent 任务执行成功（两端各一次） | ☐ |
| 8 | 每日 pull/push 纪律保持 5 天 | ☐ |
| 9 | 入口唯一（M365 Copilot）保持 5 天 | ☐ |

**判定规则**：总检查表 1–7 全勾 = 本周目标达成（One OS / Two Nodes / Shared Knowledge / Shared GitOps 成立）；8–9 是习惯项，未全勾不阻断达标，但需在复盘中记录原因。
