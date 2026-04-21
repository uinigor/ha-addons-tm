FROM homeassistant/amd64-base:latest

# Твой локальный сервер
ARG REPO_URL="http://192.168.1.211:8081/frp/"

RUN apt-get update && apt-get install -y wget ca-certificates \
    && ARCH=$(uname -m) \
    && if [ "$ARCH" = "x86_64" ]; then FRP_ARCH="amd64"; \
       elif [ "$ARCH" = "aarch64" ]; then FRP_ARCH="arm64"; \
       else FRP_ARCH="amd64"; fi \
    && wget --no-check-certificate ${REPO_URL}frp_0.58.1_linux_${FRP_ARCH}.tar.gz -O /tmp/frp.tar.gz \
    && tar -xzf /tmp/frp.tar.gz -C /tmp/ \
    && mv /tmp/frp_0.58.1_linux_${FRP_ARCH}/frpc /usr/bin/frpc \
    && chmod +x /usr/bin/frpc \
    && rm -rf /tmp/frp* \
    && apk del wget tar

# Копируем скрипт запуска
COPY run.sh /
RUN chmod a+x /run.sh

# ВАЖНО: В образах HA на базе s6-overlay скрипт запуска 
# ДОЛЖЕН вызываться через CMD без указания ENTRYPOINT
ENTRYPOINT []
CMD [ "/run.sh" ]
