#!/usr/bin/env bash

# Читаем токен
TOKEN=$(grep -oP '(?<="token": ")[^"]*' /data/options.json)

echo "[Info] Настройка Cloud Proxy TM..."

# Используем Inline Table для metas — это решает проблему "unknown field"
cat <<EOF > /tmp/frpc.toml
serverAddr = "192.168.1.211"
serverPort = 7000

[[proxies]]
name = "ha-proxy"
type = "http"
localIP = "172.30.32.1"
localPort = 8123
customDomains = ["client.ha.local"]
metas = { authToken = "${TOKEN}" }
EOF

echo "[Info] Соединение с сервером..."

# Запуск
exec /usr/bin/frpc -c /tmp/frpc.toml
