#!/usr/bin/env sh

set -eu

echo "ARGS: $*"

BUILD_ARCH="$1"
TAILSCALE_VERSION="$2"

echo "Downloading tailscale $TAILSCALE_VERSION for $BUILD_ARCH" >&2

# Convert hass arch to tailscale
case "$BUILD_ARCH" in
  armhf|armv7)
    TAILSCALE_ARCH="arm"
    ;;
  aarch64)
    TAILSCALE_ARCH="arm64"
    ;;
  amd64)
    TAILSCALE_ARCH="amd64"
    ;;
  i386)
    TAILSCALE_ARCH="386"
    ;;
esac

wget "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION}_${TAILSCALE_ARCH}.tgz" -O - | \
  tar xzf -
mv "tailscale_${TAILSCALE_VERSION}_${TAILSCALE_ARCH}"/tailscale* /bin
rm -rf "tailscale_${TAILSCALE_VERSION}_${TAILSCALE_ARCH}"

# vim: set ft=sh et ts=2 sw=2 :
