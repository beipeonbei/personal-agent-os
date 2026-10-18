# Vault — Obsidian 知识库

本目录是 Personal Agent OS 的 **Knowledge + Memory 权威源**，对应方案第三部分 Knowledge Sync。

## 结构约定（六目录）

```
Vault/
├─ Inbox/      # 速记收集区：任何东西先扔这里，当天清空归类
├─ Projects/   # 项目笔记：与 ../Projects（代码）对应，一文一项目
├─ Research/   # 研究资料：问题、来源、结论三段式
├─ AgentOS/    # Agent OS 运行笔记：模板（templates/）、运行记录、踩坑复盘
├─ Startup/    # 创业事务：事项与决策日志
└─ Daily/      # 日记：一天一篇，命名 YYYY-MM-DD
```

## 模板

模板放在 `AgentOS/templates/`：Daily Note / Project / Research / Startup Log。
Obsidian 里配置：设置 → 核心插件 → 开启"模板" → 模板文件夹路径 `AgentOS/templates`。

## 同步规则

1. 本目录纳入 **OneDrive** 同步范围（推荐做法：OneDrive 根目录建 `Vault`，用 junction 链到本路径；命令见 `Docs/Tonight-Install-Checklist.md` 步骤 3），两端各持完整副本。
2. 同时纳入 Git 版本控制（双保险防误删）。
3. 冲突副本当天合并回主文件并删除，禁止堆积。
4. **边界**：不放代码、不放配置文件、不放日志——那些归 `Projects/`、`Config/`、`Logs/`。

## Memory Sync 说明

- V1（当前）：Memory = 本目录六区，Obsidian 单源。
- 未来：Hermes 部署后（Phase 2）研究双层机制，见方案文档 3.3；Hermes 未部署前不提前虚构机制。
