#!/usr/bin/with-contenv bashio

# Enable job control
set -eum

CONFIG_PATH=/data/options.json

TAILSCALE_SOCKET="/var/run/tailscale/tailscaled.sock"
TAILSCALE_FLAGS=("$@")
TAILSCALED_FLAGS=(
  "-state" "/data/tailscaled.state"
  "-socket" "$TAILSCALE_SOCKET"
)

env_get_value() {
  local env_var
  # Convert $1 to env var name. Example: hello-world -> HELLO_WORLD
  env_var="$(tr '[:lower:]' '[:upper:]' <<< "${1//-/_}")"
  # Return env var value
  eval echo "\${${env_var}}"
}

config_get_value() {
  local env_val
  env_val="$(env_get_value "$1")"

  if [[ -n "${env_val}" ]]
  then
    echo "$env_val"
    return
  fi

  jq -r ".[\"${1}\"]" "$CONFIG_PATH"
}

config_has_value() {
  local env_val
  env_val="$(env_get_value "$1")"

  if [[ -n "${env_val}" ]]
  then
    return
  fi

  jq --exit-status \
    ".[\"${1}\"] != null and .[\"${1}\"] != \"\"" "$CONFIG_PATH" >/dev/null
}

config_value_is_true() {
  local env_val
  env_val="$(env_get_value "$1")"

  if [[ -n "${env_val}" ]]
  then
    if [[ "${env_val}" == "true" ]]
    then
      return
    else
      return 1
    fi
  fi

  jq --exit-status ".[\"${1}\"] == true" "$CONFIG_PATH" >/dev/null
}

setup_ip_forwarding() {
  if ! sysctl net.ipv4.ip_forward=1 net.ipv6.conf.all.forwarding=1
  then
    echo "Failed to setup IP forwarding" >&2
  fi
}

# Parse config to construct `tailscale up` args
if config_value_is_true 'force-reauth'
then
  TAILSCALE_FLAGS+=('-force-reauth')
fi

TAILSCALE_CONFIG_OPTIONS=(
  accept-dns
  accept-routes
  advertise-exit-node
  advertise-routes
  advertise-tags
  authkey
  exit-node
  exit-node-allow-lan-access
  host-routes
  hostname
  login-server
  netfilter-mode
  shields-up
  snat-subnet-routes
)

for it in "${TAILSCALE_CONFIG_OPTIONS[@]}"
do
  if config_has_value "$it"
  then
    TAILSCALE_FLAGS+=("--${it}=$(config_get_value "$it")")
  fi
done

# Same, but for tailscaled
if config_has_value 'port'
then
  TAILSCALED_FLAGS+=('-port' "$(config_get_value 'port')")
fi

# Debug
{
  echo "DEBUG - Tailscaled command: tailscaled ${TAILSCALED_FLAGS[*]}"
  echo "DEBUG - Tailscale command: tailscale -socket ${TAILSCALE_SOCKET} up ${TAILSCALE_FLAGS[*]}"
} >&2

# Try to set up IP forwarding if required
if grep -qE "advertise-exit-node|advertise-routes" -- "${TAILSCALE_FLAGS[@]}"
then
  setup_ip_forwarding
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
    if tailscale -socket "$TAILSCALE_SOCKET" up --reset "${TAILSCALE_FLAGS[@]}"
    then
      fg
    fi
    exit "$?"
  else
    i=$(( i + 1 ))

    echo "tailscaled hasn't started yet. Sleeping 5s" >&2
    sleep 5
  fi
done

echo "tailscaled never started" >&2
exit 1

# vim: set ft=sh et ts=2 sw=2 :
