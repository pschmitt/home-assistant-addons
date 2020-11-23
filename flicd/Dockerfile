ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG BUILD_VERSION

LABEL maintainer "Philipp Schmitt <philipp@schmitt.co>"

RUN case $(arch) in \
        x86_64|amd64) export ARCH=x86_64 ;; \
        i386) export ARCH=i386 ;; \
        armv6l|armv7l) export ARCH=armv6l ;; \
        aarch64) export ARCH=aarch64 ;; \
    esac && \
    apt-get update && \
    apt-get install -y git jq && \
    git clone https://github.com/50ButtonsEach/fliclib-linux-hci /tmp/src && \
    cp /tmp/src/bin/${ARCH}/flicd /usr/bin/flicd && \
    chmod +x /usr/bin/flicd && \
    mkdir /config && \
    rm -rf /tmp/src && \
    apt-get remove --purge -y git && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh

WORKDIR /data
VOLUME ["/data"]
EXPOSE 5551
ENTRYPOINT ["/run.sh"]
