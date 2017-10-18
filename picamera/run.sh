#!/usr/bin/env bash

CONFIG_PATH=/data/options.json

AUTH_USERNAME="$(jq --raw-output '.username // empty' $CONFIG_PATH)"
AUTH_PASSWORD="$(jq --raw-output '.password // empty' $CONFIG_PATH)"
RESOLUTION="$(jq --raw-output '.resolution // empty' $CONFIG_PATH)"
FRAMERATE="$(jq --raw-output '.framerate // empty' $CONFIG_PATH)"
HFLIP="$(jq --raw-output '.hflip // empty' $CONFIG_PATH)"
VFLIP="$(jq --raw-output '.vflip // empty' $CONFIG_PATH)"
ROTATION="$(jq --raw-output '.rotation // empty' $CONFIG_PATH)"

export AUTH_USERNAME="${AUTH_USERNAME:-pi}"
export AUTH_PASSWORD="${AUTH_PASSWORD:-picamera}"
export RESOLUTION="${RESOLUTION:-800x600}"
export FRAMERATE="${FRAMERATE:-24}"
export HFLIP="${HFLIP:-false}"
export VFLIP="${VFLIP:-false}"
export ROTATION="${ROTATION:-0}"

exec python /web_streaming.py
