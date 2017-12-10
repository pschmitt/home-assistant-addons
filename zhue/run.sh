#!/usr/bin/env bash

# Extract config data
CONFIG_PATH=/data/options.json
HASS_URL=$(jq --raw-output ".hass_url" "$CONFIG_PATH")
HASS_PASSWORD=$(jq --raw-output ".hass_password" "$CONFIG_PATH")
HUE_BRIDGE=$(jq --raw-output ".hue_bridge" "$CONFIG_PATH")
HUE_USERNAME=$(jq --raw-output ".hue_username" "$CONFIG_PATH")
HUE_SWITCH=$(jq --raw-output ".hue_switch" "$CONFIG_PATH")

# Run zhue
exec python -m zhue.cli -b "$HUE_BRIDGE" -u "$HUE_USERNAME" switch "$HUE_SWITCH" -w \
  -H "$HASS_URL" -P "$HASS_PASSWORD"
