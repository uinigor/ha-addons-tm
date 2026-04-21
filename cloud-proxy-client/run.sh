#!/usr/bin/env bash

# Читаем токен
TOKEN=$(grep -oP '(?<="token": ")[^"]*' /data/options.json)

echo "[Info] Настройка Cloud Proxy TM (YAML mode)..."

# Генерируем YAML конфиг
cat <<EOF > /tmp/frpc.yaml
serverAddr: "192.168.1.211"
serverPort: 7000

proxies:
  - name: "ha-proxy"
    type: "http"
    localIP: "172.30.32.1"
    localPort: 8123
    customDomains:
      - "client.ha.local"
    metas:
      authToken: "${TOKEN}"
EOF

echo "[Info] Подключение к серверу..."

# Запуск с указанием YAML конфига
exec /usr/bin/frpc -c /tmp/frpc.yaml
