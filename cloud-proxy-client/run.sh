#!/usr/bin/with-contenv bashio

# 1. Читаем токен
TOKEN=$(bashio::config 'token')

# 2. Настройки сервера
SERVER_ADDR="192.168.1.211"
SERVER_PORT=7000

bashio::log.info "Запуск Cloud Proxy TM..."

# 3. Генерация конфига (строго под версию 0.58.1)
cat <<EOF > /tmp/frpc.toml
serverAddr = "${SERVER_ADDR}"
serverPort = ${SERVER_PORT}

[[proxies]]
name = "ha-client-proxy"
type = "http"
localIP = "172.30.32.1"
localPort = 8123
customDomains = ["client.ha.local"]

[proxies.metas]
authToken = "${TOKEN}"
EOF

bashio::log.info "Подключение к серверу ${SERVER_ADDR} с токеном: ${TOKEN:0:5}..."

# 4. Запуск frpc
exec /usr/bin/frpc -c /tmp/frpc.toml
