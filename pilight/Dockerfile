ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update && \
    apt-get install -y wget && \
    echo "deb http://apt.pilight.org/ stable main" > /etc/apt/sources.list.d/pilight.list && \
    wget -O - http://apt.pilight.org/pilight.key | apt-key add - && \
    apt-get update && \
    apt-get install -y pilight && \
    apt-get remove -y --purge wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5000/tcp 5001/tcp

ENTRYPOINT ["/usr/local/sbin/pilight-daemon"]
CMD ["-D"]
