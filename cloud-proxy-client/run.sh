#!/usr/bin/env bash

# ====== АВТОМАТИЧЕСКАЯ НАСТРОЙКА HTTP PROXY ДЛЯ HOME ASSISTANT ======
HA_CONFIG="/config/configuration.yaml"

if [ -f "$HA_CONFIG" ]; then
    # Проверяем, добавлена ли уже наша прослойка
    if grep -q "172.0.0.0/8" "$HA_CONFIG"; then
        echo "[Info] Настройки trusted_proxies уже присутствуют в configuration.yaml"
    else
        echo "[Info] Настройки прокси не найдены. Автоматически добавляем блок http..."
        
        # Дописываем блок http и доверенную подсеть Docker в конец файла
        echo -e "\n\n# Автоматическая настройка реверс-прокси от Cloud Proxy" >> "$HA_CONFIG"
        echo "http:" >> "$HA_CONFIG"
        echo "  use_x_forwarded_for: true" >> "$HA_CONFIG"
        echo "  trusted_proxies:" >> "$HA_CONFIG"
        echo "    - 172.0.0.0/8" >> "$HA_CONFIG"
        
        echo "[Info] Настройки trusted_proxies успешно добавлены!"
    fi
else
    echo "[Warning] Файл configuration.yaml не найден по пути /config/"
fi
# ===================================================================

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
