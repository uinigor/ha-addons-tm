FROM homeassistant/amd64-base:latest

# Твой локальный сервер
ARG REPO_URL="http://192.168.1.211:8081/frp/"

# Автоматическое определение архитектуры и скачивание frpc 0.58.1
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then FRP_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then FRP_ARCH="arm64"; \
    elif [ "$ARCH" = "armv7l" ]; then FRP_ARCH="arm"; \
    else FRP_ARCH="amd64"; fi && \
    # 2. Добавили полный путь в wget и tar для надежности
    wget --no-check-certificate --timeout=30 --tries=5 \
    ${REPO_URL}frp_0.58.1_linux_${FRP_ARCH}.tar.gz -O /tmp/frp.tar.gz && \
    tar -xzf /tmp/frp.tar.gz -C /tmp/ && \
    mv /tmp/frp_0.58.1_linux_${FRP_ARCH}/frpc /usr/bin/frpc && \
    chmod +x /usr/bin/frpc && \
    rm -rf /tmp/frp*

# Копируем скрипт запуска
COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
