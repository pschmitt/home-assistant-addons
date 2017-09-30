FROM resin/rpi-raspbian

ARG BUILD_FROM
# FROM $BUILD_FROM

ARG BUILD_ARCH
ARG BUILD_VERSION

LABEL maintainer "Philipp Schmitt <philipp@schmitt.co>"

RUN apt-get update && \
    apt-get install -y build-essential cmake git libunwind-dev libpcap-dev && \
    git clone --depth 5 -b master https://github.com/pilight/pilight.git /tmp/pilight && \
    cd /tmp/pilight && \
    cmake . && \
    make install && \
    apt-get remove --purge build-essential cmake git && \
    apt-get autoremove && \
    rm -rf /tmp/pilight /var/lib/apt/lists/*

# VOLUME ["/config"]

EXPOSE 5000/tcp 5001/tcp

ENTRYPOINT ["/usr/local/sbin/pilight-daemon"]
CMD ["-D"]
