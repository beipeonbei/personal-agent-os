# OpenHands — Agent 执行中心

定位（方案第四部分论证结论）：**OpenHands = Agent Execution Center，不是最终 Workbench**。它被 Chief（M365 Copilot）派发调用，负责任务级自主执行；最终工作台由未来的 Personal Agent Portal 承担。

## 目录用途

```
OpenHands/
├─ config/      # OpenHands 本地配置（敏感项进 .gitignore，见根目录规则）
├─ tasks/       # 任务单： Chief 派发 → 落这里 → 执行 → 验收
└─ workspace -> ../Projects   # 执行工作区统一指向 Projects/（可用 junction/软链）
```

## 运行规则

1. **只被调用，不被围绕**：人不直接"泡"在 OpenHands 里干活；入口始终是 M365 Copilot。
2. 任务单格式：目标、范围（限定 `Projects/` 子目录）、验收标准、日志位置。
3. 执行记录一律写 `../Logs/`，日志不入 GitHub。
4. 沙箱优先：能用 Docker 沙箱执行的任务不进宿主机直跑（Home Node 必装 Docker 的原因）。
5. 交付验收：执行结果回到 Chief/人，不自动视为完成。

## 状态

- 当前状态：**待安装**（两节点必装档，见方案第二部分安装顺序）。
