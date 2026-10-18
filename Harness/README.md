# Harness — DeepSeek Harness Runtime 层（未安装）

> **当前状态：两台电脑均未安装 DeepSeek Harness。本目录是 Runtime 接口预留占位，不虚构其能力。**

## 规划定位（Q3 落地）

DeepSeek Harness 上线后成为 Personal Agent OS 的 **Runtime 层**：Agent Team 的调度与执行底座。V1 阶段全部相关设计只做“接口预留”，即：所有未来要接 Harness 的位置先留好契约，不写死实现。

## 预留接口（V1 契约，非实现）

| 接口 | 用途 | 对接方 |
| --- | --- | --- |
| `task.submit` | 接收 Chief / Hermes 派发的任务单 | Chief、Hermes（未来） |
| `task.status` | 任务状态查询（待派发/执行中/待验收） | Portal Runtime Center |
| `agent.dispatch` | 向 OpenHands 或 Agent Team 成员派发执行 | OpenHands |
| `event.stream` | 执行事件流（供 Portal 与日志消费） | Portal、Logs |

## 接入前提

1. Home Node 从零部署 Harness（依赖 WSL2 + Docker 底座，故 Home Node 必装 Docker）；
2. `Agents/roles.yaml` 中 reserved 状态的 Agent 在此阶段激活试调度；
3. Agent Config Sync 增加 Policy 强制校验（Schema 不合法的定义不得进入 Runtime）。

## 状态

- 当前状态：**未安装**。90 天路线阶段 3（Day 61–90）从零部署，见方案第七部分。
