#!/usr/bin/with-contenv bashio

# Enable job control
set -eum

# CONFIG_PATH=/data/options.json
TAILSCALE_SOCKET="/var/run/tailscale/tailscaled.sock"
TAILSCALE_FLAGS=()
TAILSCALED_FLAGS=(
  "-state" "/data/tailscaled.state"
  "-socket" "$TAILSCALE_SOCKET"
)

# Parse config to construct `tailscale up` args
if bashio::config.has_value 'auth_key'
then
  TAILSCALE_FLAGS+=('-authkey' "$(bashio::config 'auth_key')")
fi

if bashio::config.has_value 'force_reauth' && \
  bashio::config.true 'force_reauth'
then
  TAILSCALE_FLAGS+=('-force-reauth')
fi

if bashio::config.has_value 'hostname'
then
  TAILSCALE_FLAGS+=('-hostname' "$(bashio::config 'hostname')")
fi

if bashio::config.has_value 'port'
then
  TAILSCALED_FLAGS+=('-port' "$(bashio::config 'port')")
fi

# Start tailscaled in the background
tailscaled -cleanup "${TAILSCALED_FLAGS[@]}"
tailscaled "${TAILSCALED_FLAGS[@]}" &

# Loop to wait for tailscaled to start
i=0
while [[ "$i" -lt 12 ]] # 12 x 5s = 60s
do
  if [[ -e "$TAILSCALE_SOCKET" ]]
  then
    # bring up the tunnel and fg tailscaled
    if tailscale -socket "$TAILSCALE_SOCKET" up "${TAILSCALE_FLAGS[@]}"
    then
      fg
    fi
    exit "$?"
  else
    i+=1
    echo "tailscaled hasn't started yet. Sleeping 5s" >&2
    sleep 5
  fi
done

echo "tailscaled never started" >&2
exit 1

# vim: set ft=sh et ts=2 sw=2 :
