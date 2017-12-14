#!/usr/bin/env bash

# Extract config data
CONFIG_PATH=/data/options.json
HASS_URL=$(jq --raw-output ".hass_url" "$CONFIG_PATH")
HASS_PASSWORD=$(jq --raw-output ".hass_password" "$CONFIG_PATH")
HUE_BRIDGE=$(jq --raw-output ".hue_bridge" "$CONFIG_PATH")
HUE_USERNAME=$(jq --raw-output ".hue_username" "$CONFIG_PATH")
HUE_SWITCH=$(jq --raw-output ".hue_switch" "$CONFIG_PATH")

if [[ -n "$HUE_BRIDGE" ]]
then
  BRIDGE_COMMAND="-b $HUE_BRIDGE"
fi

if [[ "$HASS_URL" == "http://hassio/homeassistant/api" ]]
then
  HASS_PASSWORD="${API_TOKEN:-$HASS_PASSWORD}"
  # Use the same Hue username as HASS
  if [[ -r /config/phue.conf ]]
  then
    echo "Reading Hue username from phue.conf"
    HUE_USERNAME=$(jq -r '.[].username' /config/phue.conf)
  fi
fi

# Run zhue
exec python -m zhue.cli $BRIDGE_COMMAND -u "$HUE_USERNAME" \
  switch "$HUE_SWITCH" \
  -w --ignore-pressed-events \
  -H "$HASS_URL" -P "$HASS_PASSWORD"
