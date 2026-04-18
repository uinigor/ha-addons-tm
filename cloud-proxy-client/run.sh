#!/bin/bash

# Чтение токена и домена напрямую из файла настроек аддона
TOKEN=$(jq -r '.token' /data/options.json)
DOMAIN=$(jq -r '.custom_domain' /data/options.json)

# Адрес вашего сервера (проверьте, 144 или 211!)
SERVER_ADDR="192.168.1.211"
SERVER_PORT=7000

echo "Запуск Cloud Proxy TM..."
echo "Домен: ${DOMAIN}"

# Генерация конфига
cat <<EOF > /tmp/frpc.toml
serverAddr = "${SERVER_ADDR}"
serverPort = ${SERVER_PORT}
auth.method = "token"
auth.token = "${TOKEN}"

[[proxies]]
name = "ha-access-${DOMAIN}"
type = "http"
localIP = "127.0.0.1"
localPort = 8123
customDomains = ["${DOMAIN}"]
EOF

echo "Конфигурация готова. Подключаемся к серверу ${SERVER_ADDR}..."
exec /usr/bin/frpc -c /tmp/frpc.toml
