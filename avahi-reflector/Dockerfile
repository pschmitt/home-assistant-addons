ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf
COPY run.sh /run.sh

RUN apk add --no-cache avahi jq && chmod +x /run.sh

CMD ["/run.sh"]
