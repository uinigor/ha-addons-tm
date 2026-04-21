#!/usr/bin/env bash

# Читаем токен
TOKEN=$(grep -oP '(?<="token": ")[^"]*' /data/options.json)

echo "[Info] Настройка Cloud Proxy TM..."

# Генерируем TOML (строго по спецификации v0.58.1)
cat <<EOF > /tmp/frpc.toml
serverAddr = "192.168.1.211"
serverPort = 7000

[[proxies]]
name = "ha-proxy"
type = "http"
localIP = "172.30.32.1"
localPort = 8123
customDomains = ["client.ha.local"]
# В v0.58.1 метаданные внутри прокси пишутся так:
[proxies.metas]
authToken = "${TOKEN}"
EOF

echo "[Info] Подключение к серверу..."

# Запуск
exec /usr/bin/frpc -c /tmp/frpc.toml
