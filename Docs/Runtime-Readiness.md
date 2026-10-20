# Runtime-Readiness（DeepSeek Harness 就绪度检查）

> 时间：2026-10-20 · **本检查不解决 API Key**，只验证各项是否就绪
> 组件：DeepSeek Harness (dsh) `@deepseek-ai/dsh@0.1.1-rc.2`

## 1. 七项就绪度（实测）

| 项 | 状态 | 证据 |
| --- | --- | --- |
| **启动项** | ✅ 就绪 | 计划任务 `DSH-DeepSeekHarness` State=Ready（AtLogOn）；当前 8080 已在监听 |
| **服务在线** | ✅ 就绪 | `127.0.0.1:8080` 端口监听 = True（自 2026-10-19 拉起后持续在线） |
| **环境变量** | ⚠️ 存在但失效 | `DEEPSEEK_API_KEY`（User 级）已设置；服务端返回 **401 invalid**（`check_dsh_key.py` 实测）——**本次不解决** |
| **配置文件** | ⚠️ 部分缺失 | 部署脚本齐备（fix_and_launch.ps1 / launch_dsh.ps1 / install_dsh.py / install_dsh_task.ps1 / check_dsh_key.py / probe_running.py / watch_dsh.py / start_dsh_bg*.py / dsh_ready.flag）；**`dsh.json` 配方文件不存在**（复盘提及但文件缺失）；`.dsh` profile 目录为空（未初始化） |
| **Plugin** | ✅ 就绪 | 架构实证：profile = 插件 bundle 按序叠加（`@deepseek-ai/dsh-base` / `dsh-web-app` / `dsh-headless`）；`dsh plugin --profile <name>` 经 pnpm 管理；包内 `lib/plugin-*.js` 在位 |
| **SubAgent** | ✅ 架构就绪 | `config/agent-presets/` 四套预设：`code`（含 agent.cordis.yml + preset.yml）、`cordis`、`minimal`、`standard` |
| **Task / Event** | 🟡 架构在位、**功能待 key** | WebUI 可达（8080），但建任务与事件流消费需模型可用；key 失效期间无法端到端验证，**不虚构为可用** |

## 2. 原生模块状态（更新旧结论）

| 模块 | 目录 | 编译产物 |
| --- | --- | --- |
| node-pty | ✅ 存在 | ❌ `build/Release/pty.node` 不存在（未构建） |
| koffi | ✅ 存在 | 未验证编译产物 |

结论：与 2026-08-25 复盘一致——**终端类插件受限**；WebUI + 模型对话主链路不受影响。

## 3. 就绪度判定

| 维度 | 判定 |
| --- | --- |
| 程序安装 | ✅ 就绪 |
| 服务启动 | ✅ 就绪 |
| 自启任务 | ✅ 就绪 |
| 插件体系 | ✅ 就绪 |
| Agent 预设 | ✅ 就绪 |
| 部署脚本 | ✅ 就绪 |
| **模型连接** | ❌ **未就绪（唯一缺口）** |
| profile 初始化 | ⚠️ 未初始化（`.dsh` 空） |
| 配方文件 | ⚠️ `dsh.json` 缺失 |

**整体：8/9 就绪，1 项阻塞（模型连接）+ 2 项待补（profile 初始化、配方文件）。**

## 4. key 更换后的验证清单（待执行）

1. 更新 User 环境变量 `DEEPSEEK_API_KEY`
2. `python E:\AI work\DSH-Research\check_dsh_key.py` → 期望返回模型列表（非 401）
3. 重启 DSH（`fix_and_launch.ps1`，端口 8080）
4. 浏览器开 http://127.0.0.1:8080 → 建一个 Task 验证 Task 链路
5. 用 `code` preset 起一个 SubAgent 验证预设可用
6. 观察事件/任务状态刷新验证 Event 链路
7. 补建 `dsh.json` 配方文件并入库（脱敏）

## 5. 与执行链的关系

`Chief（M365 Copilot）→ Harness（DSH）→ OpenHands`：Harness 段**服务就绪**，链路上唯一断点仍是模型连接。key 就绪后即可做端到端派发验证。
