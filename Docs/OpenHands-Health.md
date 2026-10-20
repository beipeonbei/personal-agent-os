# OpenHands-Health（执行层稳定性检查）

> 时间：2026-10-20 · 五维实测

## 1. 五维结果

| 维度 | 状态 | 实测证据 |
| --- | --- | --- |
| **Docker 引擎** | ✅ 正常 | `docker version`：client 29.8.2 / server 29.8.2（守护进程在线） |
| **Container** | ✅ 正常 | `openhands \| Up 8 hours \| 127.0.0.1:8000->8000/tcp` |
| **Canvas** | ✅ 正常 | http://localhost:8000/canvas → **HTTP 200**（29509 B） |
| **Projects 挂载** | ✅ 正常 | `inspect` 挂载表：`D:\Personal-Agent-OS → /projects`（RW）、`C:\Users\Administrator\.openhands → /home/openhands/.openhands`（RW） |
| **自动重启** | ✅ 正常且已实证 | 重启策略 `unless-stopped`；**实证：2026-10-19 Docker Desktop 意外停止后，容器随引擎恢复自动拉起，本次检测为 Up 8 hours** |

## 2. 稳定性事件时间线

| 时间 | 事件 | 结果 |
| --- | --- | --- |
| 2026-10-18 | 容器首次启动（当时挂载误为 Projects 子目录） | 修正为 OS 根目录后重跑 |
| 2026-10-19 | Docker Desktop 进程意外停止（0 进程，管道消失） | 重启 Docker Desktop；本次检测容器已自动恢复（Up 8h） |
| 2026-10-20 | 全面检测 | 五维全绿 |

**结论**：`--restart unless-stopped` 策略在真实故障中生效，执行层具备自恢复能力。

## 3. 已知注意事项

| 项 | 说明 |
| --- | --- |
| Docker Desktop 需开机自启 | 若 Docker Desktop 未随系统启动，容器在引擎起来前不可用（引擎启动后自动补起） |
| 宿主机会话的 `DOCKER_HOST` | 曾出现 User 级污染值（已永久删除）；新开 PowerShell 干净，个别旧会话仍继承旧值时需在命令前清除 |
| 端口占用 | 8000 被占时改用 8001（`-p 127.0.0.1:8001:8000`） |
| 容器内可见性 | 2026-10-19 实测容器内 `ls /projects` 可见 12 个目录；本轮未重复验证（挂载表已确认正确） |

## 4. 判定

**执行层：健康（5/5）**。当前 OpenHands 是系统中稳定性最好的一层——自恢复已实证、挂载正确、界面可达。
