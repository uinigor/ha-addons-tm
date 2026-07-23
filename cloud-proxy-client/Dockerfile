# Используем официальный легковесный Alpine Linux в качестве базы
FROM alpine:latest

# Переменная для автоматического определения архитектуры устройства (amd64 / arm64)
ARG TARGETARCH

# Добавляем grep для парсинга токена
RUN apk add --no-cache wget ca-certificates tar grep \
    && if [ "${TARGETARCH}" = "amd64" ]; then FRP_ARCH="linux_amd64"; \
       elif [ "${TARGETARCH}" = "arm64" ]; then FRP_ARCH="linux_arm64"; \
       elif [ "${TARGETARCH}" = "arm" ]; then FRP_ARCH="linux_arm"; \
       else echo "Unsupported architecture: ${TARGETARCH}" && exit 1; fi \
    && wget --no-check-certificate "https://github.com/fatedier/frp/releases/download/v0.58.1/{FRP_ARCH}.tar.gz" -O /tmp/frp.tar.gz \
    && tar -xzf /tmp/frp.tar.gz -C /tmp/ \
    && mv /tmp/frp_0.58.1_${FRP_ARCH}/frpc /usr/bin/frpc \
    && chmod +x /usr/bin/frpc \
    && rm -rf /tmp/frp* \
    && apk del wget tar

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT []
CMD [ "/run.sh" ]
