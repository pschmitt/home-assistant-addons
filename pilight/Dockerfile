ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG BUILD_VERSION

LABEL maintainer "Philipp Schmitt <philipp@schmitt.co>"

RUN apt-get update && \
    apt-get install -y apt-transport-https wget gnupg jq && \
    echo "deb http://apt.pilight.org/ stable main" > /etc/apt/sources.list.d/pilight.list && \
    wget -O - http://apt.pilight.org/pilight.key | apt-key add - && \
    apt-get update && \
    apt-get install -y pilight && \
    apt-get remove -y --purge wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
    
RUN echo 11 > /sys/class/gpio/export

COPY pilight-config.json /etc/pilight/config.json
COPY run.sh /run.sh

EXPOSE 5000/tcp 5001/tcp

ENTRYPOINT ["/run.sh"]
