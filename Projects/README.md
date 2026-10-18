# Projects — 项目工作区

所有项目代码与项目级文档放这里，随 GitHub 仓库 `personal-agent-os` 管理（GitOps Sync）。

## 规则

1. 一个项目一个子目录：`Projects/<项目名>/`，项目名用小写连字符，如 `agent-portal`。
2. 每个项目子目录自带 `README.md`（目标、状态、负责人节点）。
3. OpenHands 的任务工作区默认指向 `Projects/`，执行记录写 `Logs/`。
4. 项目代码提交带节点前缀：`[office]` / `[home]`。
5. 大文件（数据集、模型权重）不入库，放本地并在此登记路径。

## 与 Vault 的分界

- `Projects/`：代码、可运行产物、项目文档。
- `Vault/`：知识、笔记、复盘。
- 项目中的“经验沉淀”应提炼后写入 `Vault/Knowledge/`，不在项目目录里堆笔记。
