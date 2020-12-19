#!/usr/bin/env bash

CONFIG_PATH=/data/options.json
AVAHI_CONFIG_PATH=/etc/avahi/avahi-daemon.conf

ALLOW_INTERFACES="$(jq --raw-output '.allow_interfaces // [] | join(",")' \
                    "$CONFIG_PATH")"

# Edit avahi config
# Enable reflector, disable DBUS
sed -ir \
  -e 's/^#?enable-reflector=.*/enable-reflector=yes/' \
  -e 's/^#?enable-dbus=.*/enable-dbus=no/' \
  "$AVAHI_CONFIG_PATH"

# Set allow-interfaces
if [[ -n "$ALLOW_INTERFACES" ]]
then
  {
    echo "Setting allow-interfaces to $ALLOW_INTERFACES"
    echo "$ grep -v '^#' $AVAHI_CONFIG_PATH"
    grep -v '^#' "$AVAHI_CONFIG_PATH"
  } >&2
  sed -ir \
    -e 's/^#?allow-interfaces=.*/allow-interfaces='"${ALLOW_INTERFACES}"'/' \
    "$AVAHI_CONFIG_PATH"
fi

exec avahi-daemon
