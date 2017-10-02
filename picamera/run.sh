#!/usr/bin/bash

CONFIG_PATH=/data/options.json

RESOLUTION="$(jq --raw-output '.resolution' $CONFIG_PATH)"
FRAMERATE="$(jq --raw-output '.framerate' $CONFIG_PATH)"

if [[ -z "$RESOLUTION" ]]
then
    RESOLUTION=800x60
fi

if [[ -z "$FRAMERATE" ]]
then
    FRAMERATE=24
fi

export RESOLUTION="$RESOLUTION"
export FRAMERATE="$FRAMERATE"

exec python /web_streaming.py
