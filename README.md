# xray-render-sg

在 Render 新加坡区域以 Docker 方式运行 Xray（VLESS + WebSocket）的模板仓库。

## 仓库内容

- `Dockerfile`：基于公开镜像 `teddysun/xray` 构建。
- `entrypoint.sh`：容器启动脚本，从环境变量读取配置，现场生成 `/etc/xray/config.json` 后再启动 Xray。
- `README.md`：本说明。

> 安全说明：本仓库不包含任何真实的 UUID、WebSocket 路径或密钥。所有敏感配置都通过 Render 的环境变量注入，绝不要把它们写进仓库文件或提交记录里。

## 环境变量

| 变量名    | 说明 | 示例（占位符，请替换为自己生成的值） |
|-----------|------|--------------------------------------|
| `UUID`    | VLESS 客户端 UUID，请全新生成，不要复用已有节点的凭证 | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `WS_PATH` | WebSocket 路径，以 `/` 开头，请使用随机字符串 | `/REPLACE_ME_WITH_RANDOM_PATH` |
| `PORT`    | 监听端口，Render 会自动注入，一般无需手动设置 | `10000` |

## 在 Render 上部署（免费）

1. 在 Render 控制台新建 Web Service，选择「从 Git 仓库构建」，关联本仓库。
2. 区域选择 Singapore（新加坡），实例类型选择 Free，不绑定银行卡、不付费。
3. 在 Environment Variables 中添加 `UUID` 与 `WS_PATH`（使用全新生成的值，不要复用已有节点）。
4. 创建后等待构建部署完成，状态变为 Live 即可。

## 客户端配置要点

- 协议：VLESS，传输：WebSocket + TLS
- 地址：Render 分配的 `*.onrender.com` 域名，端口 `443`
- `encryption=none`，`host` 与路径按环境变量填写

## 注意事项

- 免费实例在长时间无请求后会休眠，首次访问可能需要等待唤醒。
- 不要把真实 UUID / 路径提交到本仓库。
