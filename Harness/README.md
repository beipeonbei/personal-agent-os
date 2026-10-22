# Harness — DeepSeek Harness Runtime 层（在线，未接线）

> 实测状态（2026-10-22）：**8080 端口监听中**（health-check `dsh_8080 = PASS`）。
> 自启任务 `DSH-DeepSeekHarness`（AtLogOn）状态 Ready，故开机后 DSH 会自己起来。
> **模型连接不可用**：`DEEPSEEK_API_KEY` 存在但服务端返回 401（key 失效），需你充值或换 key。
> **未接线**：本层当前不派发、不接任务，属占位在线状态（见裁决 C-4：派发链须排在 Execution Broker 之后）。

## 启动配方（照抄即可）

```powershell
$env:HTTP_PROXY=''; $env:HTTPS_PROXY=''; $env:http_proxy=''; $env:https_proxy=''; $env:NO_PROXY='*'
Start-Process -FilePath 'C:\Users\Administrator\AppData\Local\hermes\node\node.exe' `
  -ArgumentList 'C:\Users\Administrator\AppData\Local\hermes\node\node_modules\@deepseek-ai\dsh\lib\bin.js','web','--port','8080','--no-open' `
  -WorkingDirectory 'E:\AI work\DSH-Research' `
  -RedirectStandardOutput 'E:\AI work\DSH-Research\dsh_out.log' `
  -RedirectStandardError 'E:\AI work\DSH-Research\dsh_err.log' -WindowStyle Hidden
```

验证：

```powershell
Test-NetConnection -ComputerName 127.0.0.1 -Port 8080 -InformationLevel Quiet   # 期望 True
(Invoke-WebRequest 'http://127.0.0.1:8080' -UseBasicParsing).StatusCode          # 期望 200
python 'E:\AI work\DSH-Research\check_dsh_key.py'                                # 期望返回模型列表，非 401
```

## 三个已知绕坑项（历史实测，别踩）

1. **别用 npx**：npx 每次临时解析并下载会卡死 → 用全局安装入口 `node lib/bin.js`。
2. **npm 安装加 `--maxsockets=1` 并清空代理变量**：Clash 并发拦截会让 npm 卡住。
3. **端口**：默认 3080 历史上被占 → 固定用 **8080**。

## 已知限制

- `node-pty` / `koffi` 原生模块未构建（无 MSVC 编译链）→ 终端类插件受限；WebUI 与模型对话主链路不受影响
- `dsh.json` 配方文件**不存在**（复盘提及但文件缺失）→ 配方以本文件命令为准
- `.dsh` profile 目录为空 → 未初始化

## 预留接口契约（未实现，合流后才做）

| 接口 | 用途 |
| --- | --- |
| `task.submit` | 接收 Chief 派发的任务单 |
| `task.status` | 任务状态查询 |
| `agent.dispatch` | 向 OpenHands 派发执行 |
| `event.stream` | 执行事件流（供日志消费） |

**解禁条件**：Identity Runtime 与 Budget Runtime 均建成后才可做 Execution Broker 与本层接线。
