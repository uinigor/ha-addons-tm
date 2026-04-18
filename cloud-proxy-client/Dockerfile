ARG BUILD_FROM=homeassistant/amd64-base:latest
FROM $BUILD_FROM

RUN apk add --no-cache jq wget

# Автоматическое определение архитектуры и скачивание frpc 0.58.1
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then FRP_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then FRP_ARCH="arm64"; \
    elif [ "$ARCH" = "armv7l" ]; then FRP_ARCH="arm"; \
    else FRP_ARCH="amd64"; fi && \
    wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v0.58.1/frp_0.58.1_linux_${FRP_ARCH}.tar.gz && \
    tar -xzf frp_0.58.1_linux_${FRP_ARCH}.tar.gz && \
    mv frp_0.58.1_linux_${FRP_ARCH}/frpc /usr/bin/frpc && \
    chmod +x /usr/bin/frpc && \
    rm -rf frp_0.58.1_linux_${FRP_ARCH}*

# Копируем скрипт запуска
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
