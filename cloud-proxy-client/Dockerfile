FROM homeassistant/amd64-base:latest

# Твой локальный сервер
ARG REPO_URL="http://192.168.1.211:8081/frp/"

# Установка зависимостей и скачивание frpc 0.58.1
RUN apk add --no-cache wget ca-certificates tar \
    && ARCH=$(uname -m) \
    && if [ "$ARCH" = "x86_64" ]; then FRP_ARCH="amd64"; \
       elif [ "$ARCH" = "aarch64" ]; then FRP_ARCH="arm64"; \
       else FRP_ARCH="amd64"; fi \
    # 2. Скачивание и распаковка
    && wget --no-check-certificate ${REPO_URL}frp_0.58.1_linux_${FRP_ARCH}.tar.gz -O /tmp/frp.tar.gz \
    && tar -xzf /tmp/frp.tar.gz -C /tmp/ \
    && mv /tmp/frp_0.58.1_linux_${FRP_ARCH}/frpc /usr/bin/frpc \
    && chmod +x /usr/bin/frpc \
    # 3. Чистка
    && rm -rf /tmp/frp* \
    && apk del wget tar

# Копируем скрипт запуска
COPY run.sh /
RUN chmod a+x /run.sh

# Используем CMD для s6-overlay
CMD [ "/run.sh" ]
