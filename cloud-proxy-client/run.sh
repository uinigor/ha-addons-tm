#!/usr/bin/with-contenv bashio

TOKEN=$(bashio::config 'token')
DOMAIN=$(bashio::config 'custom_domain')
SERVER_ADDR="192.168.1.211"
SERVER_PORT=7000

echo "Настройка подключения для домена: ${DOMAIN}"

# Формируем конфиг TOML для frp 0.58.1
cat <<EOF > /tmp/frpc.toml
serverAddr = "${SERVER_ADDR}"
serverPort = ${SERVER_PORT}

auth.method = "token"
auth.token = "${TOKEN}"

[[proxies]]
name = "web-access"
type = "http"
localIP = "127.0.0.1"
localPort = 8123
customDomains = ["${DOMAIN}"]
EOF

echo "Конфигурация создана. Запуск frpc..."
exec /usr/bin/frpc -c /tmp/frpc.toml
