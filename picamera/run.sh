#!/usr/bin/env bash

CONFIG_PATH=/data/options.json

AUTH_USERNAME="$(jq --raw-output '.username' $CONFIG_PATH)"
AUTH_PASSWORD="$(jq --raw-output '.password' $CONFIG_PATH)"
RESOLUTION="$(jq --raw-output '.resolution' $CONFIG_PATH)"
FRAMERATE="$(jq --raw-output '.framerate' $CONFIG_PATH)"

if [[ -z "$AUTH_USERNAME" ]]
then
    AUTH_USERNAME="pi"
fi

if [[ -z "$AUTH_PASSWORD" ]]
then
    AUTH_PASSWORD="picamera"
fi

if [[ -z "$RESOLUTION" ]]
then
    RESOLUTION=800x600
fi

if [[ -z "$FRAMERATE" ]]
then
    FRAMERATE=24
fi

export AUTH_USERNAME="$AUTH_USERNAME"
export AUTH_PASSWORD="$AUTH_PASSWORD"
export RESOLUTION="$RESOLUTION"
export FRAMERATE="$FRAMERATE"

exec python /web_streaming.py
