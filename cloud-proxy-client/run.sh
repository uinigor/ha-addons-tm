#!/usr/bin/with-contenv bashio

TOKEN=$(bashio::config 'token')
SERVER_ADDR="192.168.1.211"
SERVER_PORT=7000

echo "Запуск Cloud Proxy TM..."

# Генерируем конфиг
cat <<EOF > /tmp/frpc.toml
serverAddr = "${SERVER_ADDR}"
serverPort = ${SERVER_PORT}
auth.method = "token"
auth.token = "${TOKEN}"

[[proxies]]
name = "ha-tm-${TOKEN:0:6}"
type = "tcp"
localIP = "127.0.0.1"
localPort = 8123
remotePort = 8124
EOF

echo "Подключаемся к серверу ${SERVER_ADDR}..."
exec /usr/bin/frpc -c /tmp/frpc.toml
