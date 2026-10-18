# Prompts — Prompt 资产库

系统级与可复用 Prompt 的存放地，随 GitHub 仓库同步（GitOps Sync）。

## 文件

| 文件 | 说明 |
| --- | --- |
| `system-prompts.md` | Chief 初始提示词、任务派发模板、研究沉淀模板、同步巡检口令 |
| `README.md` | 本说明 |

## 规则

1. 本目录与 `Agents/` 分工：`Agents/roles.yaml` 定义“谁是谁、能干什么”；本目录定义“怎么说话、怎么派活”。
2. 一次性任务单不进本目录，放 `OpenHands/tasks/`。
3. Prompt 迭代留版本记录，提交信息注明变更原因。
4. 不在 Prompt 里写死具体项目事实（那些放 Vault）。
