#!/bin/sh
# 启动入口：从环境变量读取配置，现场生成 Xray 配置文件后启动。
# 必需的环境变量：
#   UUID    - VLESS 客户端 UUID（请使用全新生成的，不要复用已有节点的）
#   WS_PATH - WebSocket 路径，以 / 开头（请使用随机字符串，不要把真实值提交到仓库）
# 可选的环境变量：
#   PORT    - 监听端口（Render 会自动注入 PORT，一般无需手动设置）
set -eu

if [ -z "${UUID:-}" ]; then
  echo "错误: 必须设置环境变量 UUID" >&2
  exit 1
fi
if [ -z "${WS_PATH:-}" ]; then
  echo "错误: 必须设置环境变量 WS_PATH" >&2
  exit 1
fi
PORT="${PORT:-8080}"

# 定位 xray 可执行文件
if command -v xray >/dev/null 2>&1; then
  XRAY_BIN="$(command -v xray)"
else
  XRAY_BIN=""
  for p in /usr/bin/xray /usr/local/bin/xray; do
    if [ -x "$p" ]; then XRAY_BIN="$p"; break; fi
  done
fi
if [ -z "$XRAY_BIN" ]; then
  echo "错误: 找不到 xray 可执行文件" >&2
  exit 1
fi

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "${UUID}" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

echo "配置已生成，正在启动 Xray（监听端口 ${PORT}）..."
exec "$XRAY_BIN" -config /etc/xray/config.json
