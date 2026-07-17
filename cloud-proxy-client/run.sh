#!/usr/bin/env bash

# Читаем токен
TOKEN=$(grep -oP '(?<="token": ")[^"]*' /data/options.json)

echo "[Info] Настройка Cloud Proxy (Safe Mode)..."

# Генерируем конфиг БЕЗ поля metas
# Токен упаковываем в имя прокси через разделитель "_"
cat <<EOF > /tmp/frpc.toml
serverAddr = "smart.net.tm"
serverPort = 7000

[[proxies]]
name = "ha_${TOKEN}"
type = "http"
localIP = "172.30.32.1"
localPort = 8123
customDomains = ["client.smart.net.tm"]
EOF

echo "[Info] Подключение к серверу..."
exec /usr/bin/frpc -c /tmp/frpc.toml
