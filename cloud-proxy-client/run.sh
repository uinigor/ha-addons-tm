#!/usr/bin/with-contenv bashio

# 1. Читаем токен через bashio (безопасный способ для HA)
TOKEN=$(bashio::config 'token')

# 2. Настройки твоего сервера
SERVER_ADDR="192.168.1.211"
SERVER_PORT=7000

bashio::log.info "Запуск Cloud Proxy TM..."

# 3. Генерация конфига в формате TOML
cat <<EOF > /tmp/frpc.toml
serverAddr = "${SERVER_ADDR}"
serverPort = ${SERVER_PORT}

[auth]
method = "token"
token = ""

[[proxies]]
name = "ha-client-proxy"
type = "http"
localIP = "127.0.0.1"
localPort = 8123
# Используем временный домен, сервер сам его подменит на правильный из базы
customDomains = ["temporary.ha.local"]
# Передаем реальный токен в метаданных
metas.authToken = "${TOKEN}"
EOF

bashio::log.info "Подключение к серверу ${SERVER_ADDR}..."

# 4. Запуск frpc
exec /usr/bin/frpc -c /tmp/frpc.toml
