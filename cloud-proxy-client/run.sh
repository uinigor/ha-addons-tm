#!/usr/bin/env bash

# 1. Читаем токен напрямую из файла настроек HA
# (Тут мы используем простую замену, так как jq может не быть в образе)
TOKEN=$(grep -oP '(?<="token": ")[^"]*' /data/options.json)

echo "[Info] Настройка Cloud Proxy TM..."

# 2. Генерация конфига в формате TOML (Исправленный формат для v0.58.1)
cat <<EOF > /tmp/frpc.toml
serverAddr = "192.168.1.211"
serverPort = 7000

[[proxies]]
name = "ha-proxy"
type = "http"
localIP = "172.30.32.1"
localPort = 8123
customDomains = ["client.ha.local"]

# В TOML метаданные для конкретного прокси пишутся так:
[proxies.metas]
authToken = "${TOKEN}"
EOF

echo "[Info] Подключение к серверу с токеном: ${TOKEN:0:5}..."

# 3. Запуск frpc
exec /usr/bin/frpc -c /tmp/frpc.toml
