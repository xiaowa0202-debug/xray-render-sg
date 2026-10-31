# 基于公开镜像 teddysun/xray 构建
# 容器启动时由 entrypoint.sh 根据环境变量现场生成 /etc/xray/config.json，
# 仓库与镜像中均不保存任何真实 UUID / WS 路径 / 密钥。
FROM teddysun/xray:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
