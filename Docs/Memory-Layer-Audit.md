# Memory-Layer-Audit（Memory Layer 闭环审计）

> 审计时间：2026-10-20 · 全部结论基于文件与进程实测

## 1. 五件套存在性（实测）

| 组件 | 位置 | 状态 | 证据 |
| --- | --- | --- | --- |
| SOUL.md | Hermes：`AppData\Local\hermes\SOUL.md` | ✅ 存在 | JARVIS 管家核心指令（2026-08-02 部署），2273B |
| MEMORY.md | Hermes：`AppData\Local\hermes\memories\MEMORY.md` | ✅ 存在 | 8 条长期记忆（模型偏好/工作目录/项目结论等），最后写入 2026-08-19 |
| USER.md | Hermes：`memories\USER.md`（96B）／Vault：`AgentOS\USER.md`（5180B） | ⚠️ 双份未对齐 | Vault 版已重建为九节权威版；Hermes 版仍是 2026-08-02 的 96B 单条 |
| identity.md | Vault：`AgentOS\identity.md` | ✅ 存在 | Vault 权威规则 + 记忆分流规则已文档化 |
| memory-export/ | Vault：`AgentOS\memory-export\` | ⚠️ 空目录 | 仅 `.gitkeep`，**无任何导出文件** |

## 2. 闭环链路逐条判定

| 链路 | 判定 | 说明 |
| --- | --- | --- |
| Identity：SOUL.md ↔ identity.md | 🟡 半闭环 | 规则已立（identity.md 声明 Vault 权威、冲突 Vault 赢），但 SOUL.md 未回指 Vault，两份身份文件未交叉对齐 |
| Memory：MEMORY.md → memory-export/ | ❌ **未闭合** | 无导出机制、无定时导出脚本、目录零产出。Hermes 记忆仍困在其安装目录内 |
| User Model：Vault USER.md ← Hermes USER.md | 🟡 半闭环 | Vault 权威版已建；Hermes 侧未同步，仍是旧版 96B |
| 同步：Vault → OneDrive → Office Node | ❌ **未建立** | 实测 `D:\Personal-Agent-OS\Vault` 的 LinkType 为空（普通目录，非 junction），`C:\Users\Administrator\OneDrive\Vault` 不存在。**跨节点知识同步链路尚未打通** |
| 配置侧：Config/home-node.yaml | ✅ 已登记 | `hermes: ready`、memory 路径已写入 |
| 系统状态：Config/system-state.yaml | ✅ 已固化 | memory_layer 段落含权威源、导出目录、状态 |

## 3. 缺口清单（按优先级）

| # | 缺口 | 影响 | 类型 |
| --- | --- | --- | --- |
| 1 | Vault 未接入 OneDrive（无 junction） | 知识/记忆无法跨节点同步；Office Node 部署后 Vault 各走各的 | **配置缺口**（需创建 junction，涉及目录操作，待用户批准后执行） |
| 2 | memory-export 无导出机制 | Memory Layer 只进不出，Vault 权威规则形同虚设 | 机制缺口（需定时导出脚本或从 Hermes 侧写入） |
| 3 | Hermes 侧 USER.md 未对齐 | 两个用户模型并存，Agent 取用哪个不确定 | 数据缺口（可在下次 Hermes 接入时写入 Vault 版） |
| 4 | SOUL.md 未回指 identity.md | 身份双源，冲突裁决只能靠人工 | 数据缺口（在 SOUL.md 加一行回指即可，属 Hermes 数据面） |
| 5 | MEMORY.md 内容陈旧（2026-08-19 后未更新） | 记忆不反映近两月的系统建设 | 运营缺口（日常使用中自然累积） |

## 4. 闭环结论

**Memory Layer 处于"组件齐全、链路未闭"状态**：

- ✅ 有的：管理者（Hermes v0.21.7 运行中）、权威源（Vault）、四要素实证（Identity/Memory/Skill 已建立）、规则文档（identity.md）、状态固化（system-state.yaml）
- ❌ 缺的：回流通道（无导出）、跨节点通道（无 OneDrive junction）、两侧数据对齐（USER.md / SOUL.md）

判定：**未完全闭环**。三件套文件存在不等于闭环；闭环的判据是"Hermes 侧更新 → Vault 可见 → 对端节点可见"，当前三段断了两段。

## 5. 建议补齐顺序（待批准，不在本次自动执行）

1. 建 OneDrive junction（Vault 真实目录移到 OneDrive，D 盘路径 junction 回指）——打通跨节点通道
2. 建 Hermes → memory-export 导出动作（手动或定时）——打通回流通道
3. Hermes USER.md 写入 Vault 版内容——消除双份用户模型
4. SOUL.md 加一行回指 identity.md——消除身份双源
