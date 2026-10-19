# Hermes-Integration-Report（Phase 2 接入报告）

> 检测时间：2026-10-19 · 全部结论基于本机实测，非设计图推演
> 接入方式：启用既有安装 + 建立 Vault 权威同步规则，未重装、未改核心配置

## 1. Hermes 当前状态（四要素实测）

| 项 | 实测结果 |
| --- | --- |
| 运行状态 | **运行中**（桌面端 GUI 窗口 "Hermes" + 5 进程：Hermes×4 + hermes CLI×1） |
| 版本 | v0.21.7+495.g6e7b83a（2026.9.24，git 安装，Python 3.14.7） |
| 配置路径 | `C:\Users\Administrator\AppData\Local\hermes\config.yaml`（13KB）+ profile 覆盖 `profiles\test-project\config.yaml`；主模型 hy3-preview-agent |
| 数据路径 | `C:\Users\Administrator\AppData\Local\hermes\`：memories/（MEMORY.md+USER.md）、skills/（24 类）、sessions/（3558 个）、SOUL.md、auth.json、.env |
| 启动方式 | 开始菜单 `Hermes.lnk` → `hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe`；桌面端自拉 `hermes serve --host 127.0.0.1 --port 0`（GUI 专用随机端口）。**遵守单一起启动源铁律，未手动 gateway run** |

## 2. Health Check 结果

| 检查项 | 状态 | 说明 |
| --- | --- | --- |
| 进程健康 | ✅ | 桌面端 + CLI 子进程全部在跑 |
| 配置状态 | ✅ | config.yaml 完好（含多份历史备份），模型配置 hy3-preview-agent |
| 依赖状态 | ✅ | Python 3.14.7 / node（Hermes 自带 v22.x）/ OpenAI SDK 2.24.0 就绪 |
| gateway（8642） | ⚠️ 未监听 | 8642 是 default profile 的独立 gateway（承载飞书/API），桌面端不自动拉起。**Phase 2 Memory 接管不依赖它**；需要远程通道时再按既定恢复流程启动 |

已知告警（不影响接入）：上次 `hermes update` 拉到新代码但因 git 网络失败未完成重启（`.update_exit_code=1`）；v0.22.2 更新检查同样因网络失败。**决策：锁定 v0.21.7，稳定运行一周后再评估升级**。

## 3. Vault ↔ Hermes 同步规则（已建立）

落盘位置：`Vault/AgentOS/identity.md` + `Vault/AgentOS/memory-export/` + `Config/home-node.yaml`（hermes: ready）。

| 规则 | 内容 |
| --- | --- |
| 权威源 | **Vault 赢**。Identity/知识/结论以 Vault 为准，冲突当天对齐 Hermes 侧 |
| 记忆分流 | Hermes 长期记忆导出 → `Vault/AgentOS/memory-export/YYYY-MM-DD.md`（经 OneDrive 到 Office Node 只读可见） |
| 写入边界 | 知识区由人经 Obsidian 直写；Hermes 不直接改写 Vault 知识区 |
| 配置纪律 | Hermes 配置含密钥，禁止入仓；本地 backup_config.ps1 备份 |

## 4. 四要素验证（逐项实测）

| 要素 | 结论 | 证据 |
| --- | --- | --- |
| Identity | ✅ 已建立 | SOUL.md（2273B）：JARVIS 管家核心指令（2026-08-02 部署）——JARVIS 身份、服务唯一主人 Bei~、三条核心指令 |
| Memory | ✅ 已建立（偏薄） | memories/MEMORY.md（8 条：模型偏好 hy3-preview、工作目录、淘宝分析兴趣、安装信息、wxauto 问题、飞书 gateway 配置、lottery-selector 研究结论）；最后写入 2026-08-19 |
| User Model | ⚠️ 部分建立 | memories/USER.md 仅 96B（1 条 wxauto 需求），用户模型薄弱，待丰富 |
| Skill | ✅ 已建立（丰富） | skills/ 24 个分类（ai-development/data-science/github/note-taking/research/software-development/web 等）+ .hub + bundled_manifest |

## 5. 接入结论

- Hermes 作为 Memory Layer 管理者**已接管就位**：桌面端常驻 + 四要素有实证 + 同步规则落盘
- 当前 Memory 实际形态：**Hermes（memories/）+ Vault（AgentOS/）双层，Vault 权威**
- 后续动作（非阻塞）：USER.md 丰富；memory-export 每日导出机制落地；稳定一周后评估 v0.22.2 升级
