# 1. Принимаем базовый образ от сборщика Home Assistant
ARG BUILD_FROM
FROM $BUILD_FROM

# 2. Принимаем архитектуру целевого устройства от Docker (amd64, arm64 и т.д.)
ARG TARGETARCH

# 3. Устанавливаем утилиты, определяем архитектуру и скачиваем бинарник
RUN apk add --no-cache wget ca-certificates tar grep \
    && if [ "${TARGETARCH}" = "amd64" ]; then export FRP_ARCH="linux_amd64"; \
       elif [ "${TARGETARCH}" = "arm64" ]; then export FRP_ARCH="linux_arm64"; \
       elif [ "${TARGETARCH}" = "arm" ]; then export FRP_ARCH="linux_arm"; \
       else echo "Unsupported architecture: ${TARGETARCH}" && exit 1; fi \
    && wget --no-check-certificate "https://github.com/fatedier/frp/releases/download/v0.58.1/frp_0.58.1_${FRP_ARCH}.tar.gz" -O /tmp/frp.tar.gz \
    && tar -xzf /tmp/frp.tar.gz -C /tmp/ \
    && mv /tmp/frp_0.58.1_${FRP_ARCH}/frpc /usr/bin/frpc \
    && chmod +x /usr/bin/frpc \
    && rm -rf /tmp/frp* \
    && apk del wget tar

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
