ARG BUILD_ARCH
ARG BUILD_VERSION
ARG BUILD_BASE_IMAGE=zabbix/zabbix-agent2:alpine-7.4-latest

FROM ${BUILD_BASE_IMAGE} as builder

FROM alpine:3.22

LABEL org.opencontainers.image.authors="Philipp Schmitt <philipp@schmitt.co>, Lukas Magauer <lukas@magauer.eu>" \
      org.opencontainers.image.url="https://github.com/pschmitt/home-assistant-addons/tree/main/zabbix-agent2" \
      org.opencontainers.image.title="Zabbix Agent 2 image for Home Assistant Add-on" \
      org.opencontainers.image.base.name="alpine"

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk add --update-cache jq "zabbix-agent2=~7.4" zabbix-agent2-plugin-alpine && \
    addgroup -g 102 docker && \
    addgroup zabbix docker && \
    mkdir -p /etc/zabbix/zabbix_agent2.d/plugins.d && \
    apk cache clean && \
    rm -rf /var/cache/apk/*

# Copy zabbix-agent2 plugins
COPY --from=builder ["/usr/sbin/zabbix-agent2-plugin", "/usr/sbin/zabbix-agent2-plugin"]
RUN echo -e "\nPlugins.PostgreSQL.System.Path=/usr/sbin/zabbix-agent2-plugin/mongodb\nPlugins.PostgreSQL.System.Path=/usr/sbin/zabbix-agent2-plugin/postgresql\n" >> /etc/zabbix/zabbix_agent2.conf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
