ARG BUILD_ARCH
ARG BUILD_VERSION
ARG BUILD_BASE_IMAGE=zabbix/zabbix-agent2:alpine-6.4-latest

FROM ${BUILD_BASE_IMAGE} as builder

FROM alpine:3.20

LABEL maintainer "Philipp Schmitt <philipp@schmitt.co>"

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk add --no-cache jq zabbix-agent2 && \
    addgroup -g 1003 docker && \
    addgroup zabbix docker && \
    mkdir -p /etc/zabbix/zabbix_agent2.d/plugins.d

# Copy zabbix-agent2 plugins
COPY --from=builder ["/usr/sbin/zabbix-agent2-plugin", "/usr/sbin/zabbix-agent2-plugin"]
RUN echo -e "\nPlugins.PostgreSQL.System.Path=/usr/sbin/zabbix-agent2-plugin/mongodb\nPlugins.PostgreSQL.System.Path=/usr/sbin/zabbix-agent2-plugin/postgresql\n" >> /etc/zabbix/zabbix_agent2.conf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
