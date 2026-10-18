# Config — 节点配置目录

节点级配置，随 GitHub 仓库同步（GitOps Sync 的一部分）。

## 文件

| 文件 | 说明 |
| --- | --- |
| `office-node.yaml` | Office Node（公司电脑）配置 |
| `home-node.yaml` | Home Node（家里电脑）配置 |
| `README.md` | 本说明 |
| `local-*.yaml` | 本地敏感配置（token 等），**已被根 `.gitignore` 排除，永不入库** |

## 规则

1. 两文件是双节点一致性的机器可查依据：组件差集仅允许 Home 多出 `wsl2`；`hermes` 与 `deepseek_harness` 两节点当前均为 `not_installed`。
2. 组件状态变更（如装完 OpenHands）必须同步改对应节点文件并提交。
3. `commit_prefix` 用于提交信息前缀，保证 Git 历史可追溯到节点。
4. 本目录不放知识、不放代码、不放日志。
