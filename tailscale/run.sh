#!/usr/bin/with-contenv bashio

# Enable job control
set -m

CONFIG_PATH=/data/options.json

TAILSCALE_SOCKET="/var/run/tailscale/tailscaled.sock"
TAILSCALE_FLAGS=("$@")
TAILSCALED_FLAGS=(
  "-state" "/data/tailscaled.state"
  "-socket" "$TAILSCALE_SOCKET"
)

# DIRTYFIX: Remove /run.sh from tailscale flags if present
# This seems to only be present if run by Home Assistant OS
if [[ "${TAILSCALE_FLAGS[0]}" == "/run.sh" ]]
then
  TAILSCALE_FLAGS=("${TAILSCALE_FLAGS[@]:1}")
fi

config_file_get_value() {
  jq -r ".[\"${1}\"]" "$CONFIG_PATH"
}

config_file_has_value() {
  jq --exit-status \
    ".[\"${1}\"] != null and .[\"${1}\"] != \"\"" "$CONFIG_PATH" >/dev/null
}

config_file_value_is_true() {
  jq --exit-status ".[\"${1}\"] == true" "$CONFIG_PATH" >/dev/null
}

env_get_value() {
  local env_var
  # Convert $1 to env var name. Example: hello-world -> HELLO_WORLD
  env_var="$(tr '[:lower:]' '[:upper:]' <<< "${1//-/_}")"
  # Return env var value
  eval echo "\${${env_var}}" 2>/dev/null
}

config_env_get_value() {
  local env_val
  env_val="$(env_get_value "$1")"

  if [[ -n "${env_val}" ]]
  then
    echo "$env_val"
    return
  fi

  return 1
}

config_env_has_value() {
  config_env_get_value "$1" >/dev/null 2>/dev/null
}

config_env_value_is_true() {
  local env_val
  env_val="$(env_get_value "$1")"

  if [[ "${env_val}" == "true" ]]
  then
    return
  fi

  return 1
}

config_get_value() {
  local source="${2:-auto}"

  case "${source}" in
    file)
      config_file_get_value "$1"
      ;;
    env)
      config_env_get_value "$1"
      ;;
    alt)
      config_file_get_value "$1" || config_env_get_value "$1"
      ;;
    *)
      config_env_get_value "$1" || config_file_get_value "$1"
      ;;
  esac
}

config_has_value() {
  local source="${2:-auto}"

  case "${source}" in
    file)
      config_file_has_value "$1"
      ;;
    env)
      config_env_has_value "$1"
      ;;
    alt)
      config_file_has_value "$1" || config_env_has_value "$1"
      ;;
    *)
      config_env_has_value "$1" || config_file_has_value "$1"
      ;;
  esac
}

config_value_is_true() {
  local source="${2:-auto}"

  case "${source}" in
    file)
      config_file_value_is_true "$1"
      ;;
    env)
      config_env_value_is_true "$1"
      ;;
    alt)
      config_file_value_is_true "$1" || config_env_value_is_true "$1"
      ;;
    *)
      config_env_value_is_true "$1" || config_file_value_is_true "$1"
      ;;
  esac
}

setup_ip_forwarding() {
  echo "INFO: Attempt to setup IP forwarding" >&2

  local key

  for key in net.ipv4.ip_forward net.ipv6.conf.all.forwarding
  do
    if [[ "$(sysctl -n "$key")" == "1" ]]
    then
      echo "INFO: $key is already set to 1" >&2
      continue
    fi

    if ! sysctl -q "${key}=1"
    then
      echo "WARNING: Failed to set ${key}=1" >&2
    fi
  done
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

for key in "${TAILSCALE_CONFIG_OPTIONS[@]}"
do
  src="auto"
  val=""

  # For hostname, prefer the value set in the config file, rather than the env
  # var $HOSTNAME
  # -> only use $HOSTNAME if no hostname set in config file
  case "$key" in
    hostname)
      src=alt
      ;;
  esac

  if config_has_value "$key" "$src"
  then
    val="$(config_get_value "$key" "$src")"
  fi

  if [[ -n "$val" ]]
  then
    TAILSCALE_FLAGS+=("--${key}=${val}")
  fi
done

# Same, but for tailscaled
if config_has_value 'port'
then
  TAILSCALED_FLAGS+=('-port' "$(config_get_value 'port')")
fi

# Debug
{
  echo "DEBUG: Tailscaled command: tailscaled ${TAILSCALED_FLAGS[*]}"
  echo "DEBUG: Tailscale command:  tailscale -socket ${TAILSCALE_SOCKET} up ${TAILSCALE_FLAGS[*]}"
} >&2

# Try to set up IP forwarding if required
if grep -qE "advertise-exit-node|advertise-routes" <<< "${TAILSCALE_FLAGS[@]}"
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
