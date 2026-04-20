FROM homeassistant/amd64-base:latest

# Твой локальный сервер
ARG REPO_URL="http://192.168.1.211:8081/frp/"

ARG REPO_URL="http://192.168.1"
RUN apk add --no-cache wget ca-certificates tar \
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

# Копируем run.sh в корень
COPY run.sh /
RUN chmod +x /run.sh

# Снимаем все ENTRYPOINT и CMD, которые могли быть в базе, 
# и запускаем скрипт через оболочку инициализации
CMD [ "/run.sh" ]
