#!/usr/bin/env bash

# Extract config data
CONFIG_PATH=/data/options.json
HCI_DEV=$(jq --raw-output ".hci_dev // empty" "$CONFIG_PATH")

# Run flicd
exec /usr/bin/flicd -f /data/flic-db -s "0.0.0.0" -p 5551 -h "$HCI_DEV"
