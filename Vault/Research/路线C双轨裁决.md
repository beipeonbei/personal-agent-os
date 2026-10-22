# 研究：Personal-Agent-OS 该走哪条路线

## 问题

目标架构（Stage 5 指令）要求的 Identity / Budget / Execution Broker 在仓库里地基为零，如何推进？

## 来源

- `Docs/Architecture-Gap-Analysis.md`（2026-10-21 实测缺口）
- `Docs/Architecture-Alignment-Decision.md`（2026-10-22 用户裁决）
- 实测：`Config/system-state.yaml` 的 alignment 段；全库 `.jsonl` = 0；GOALS.md/RULES.md 不存在

## 结论

采用**路线 C 双轨**：

1. 第一轨（工程补齐）：自律脚本、运行清单、Vault 内容、日志——不写账本、不写权威源
2. 第二轨（治理地基）：Constitution → TaskStore → 账本 schema → Gate → 不变式 → GOALS/RULES
3. 合流后才做 Identity / Budget / Broker 与绕过测试

**关键判据**：绕过测试在无对象时写必假 PASS，故 Broker 与 Gate 建成前不写（诚实纪律）。

**已识别风险**：C-4（派发链与 Broker 入口重叠）、C-5（Vault 移 OneDrive 属权威源物理位置变更，签名缺失时完整性无从校验）——两者待你确认处置。

## 待验证

- 双轨并行是否真的互不干扰（第一轨脚本已加越轨自检：`.jsonl` = 0、无 Runtime 目录）
- C-3 例外（memory-export 直写 Vault）在宪法立条后是否可收敛为受控写入
