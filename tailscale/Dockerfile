ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG BUILD_VERSION
ARG TAILSCALE_VERSION

LABEL maintainer "Philipp Schmitt <philipp@schmitt.co>"

ENV LANG C.UTF-8

# Download and install tailscale to /bin from
# https://pkgs.tailscale.com/stable/#static
COPY install.sh /
RUN chmod a+x /install.sh
RUN /install.sh ${BUILD_ARCH} ${TAILSCALE_VERSION}

# Install iptables dependency
RUN apk add --no-cache iptables ip6tables

COPY run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
