ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG BUILD_VERSION

LABEL maintainer "Philipp Schmitt <philipp@schmitt.co>"

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk add --no-cache jq zabbix-agent2 && \
    addgroup -g 1003 docker && \
    addgroup zabbix docker

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
