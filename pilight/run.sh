#!/usr/bin/env bash

# Extract config data
CONFIG_PATH=/data/options.json
GPIO_PLATFORM=$(jq -r '.gpio_platform // empty' "$CONFIG_PATH")
GPIO_PLATFORM=${GPIO_PLATFORM:-none} # default to none

# Update pilight config
sed -ir 's/("gpio-platform"): ".*"(.*)/\1: "'"$GPIO_PLATFORM"'"\2/' /etc/pilight/config.json

# Run pilight in foreground
exec pilight-daemon -D
