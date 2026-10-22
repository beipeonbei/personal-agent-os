# Hermes — Memory / Identity 层（已接入）

> 实测状态（2026-10-22）：**v0.21.7 运行中**（桌面端 + CLI 共 5 个进程，health-check 全 PASS）。
> 本目录不再是"未安装"占位。Memory 接管完成于 2026-10-19（见 `Docs/Hermes-Integration-Report.md`）。
> 唯一遗留：Hermes 侧 `memories/USER.md` 仍是 96B 旧版，与 Vault 权威版 `Vault/AgentOS/USER.md` 未对齐（待你确认后写入）。

## 启动入口（真实路径）

| 用途 | 路径 |
| --- | --- |
| 桌面端可执行文件 | `C:\Users\Administrator\AppData\Local\hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` |
| 开始菜单快捷方式（推荐入口） | `C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Hermes.lnk` |
| CLI | `C:\Users\Administrator\AppData\Local\hermes\bin\hermes.exe` |
| 配置 | `C:\Users\Administrator\AppData\Local\hermes\config.yaml`（+ profile 覆盖 `profiles\test-project\config.yaml`） |
| 数据（memories/skills/sessions） | `C:\Users\Administrator\AppData\Local\hermes\` |

桌面端自拉命令：`hermes serve --host 127.0.0.1 --port 0`（GUI 专用随机端口）。

## 启动（照抄即可）

```powershell
Start-Process 'C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Hermes.lnk'
```

验证：

```powershell
(Get-Process Hermes, hermes -ErrorAction SilentlyContinue | Measure-Object).Count   # 期望 5
powershell -ExecutionPolicy Bypass -File 'D:\Personal-Agent-OS\Config\scripts\health-check.ps1'
```

## 铁律（违反会导致双老板互杀）

1. **唯一启动源 = 桌面端自拉**。禁止手动 `gateway run`——第二个入口会与桌面端互杀，表现为 gateway 反复重启。
2. 改 `config.yaml` 后靠 `non_interactive_local_changes: keep` 保护本地改动，重开桌面端即生效。
3. 版本看 `runtime-release.json`，不是 `hermes-agent` 目录版本。
4. Hermes 配置含密钥，**禁止入仓**；本目录只放说明，不放配置副本。
5. 记忆回流：由 `Config\scripts\memory-export.ps1` 导出到 `Vault/AgentOS/memory-export/`，状态 PARTIAL（无签名）。

## 未解决的缺口

- 开机不自启：Hermes 未注册登录启动，重启机器后需手动拉起（可挂 `ensure_hermes.ps1` 到计划任务，待你决定是否接入）
- USER.md 双份未对齐（Hermes 侧 96B vs Vault 权威版 5180B）
- 与 Vault 的 IDENTITY 回指未建立（SOUL.md 未回指 `Vault/AgentOS/identity.md`）
