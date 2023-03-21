#!/usr/bin/env ash
# shellcheck shell=dash

config_get() {
  local config=/data/options.json
  jq --raw-output ".${1}" "$config"
}

# shellcheck disable=2155
{
  export KEEPALIVED_INTERFACE="$(config_get interface)"
  export KEEPALIVED_PASSWORD="$(config_get password)"
  export KEEPALIVED_PRIORITY="$(config_get priority)"
  export KEEPALIVED_ROUTER_ID="$(config_get router_id)"
  export KEEPALIVED_VIRTUAL_IPS="$(config_get virtual_ips)"
  export KEEPALIVED_COMMAND_LINE_ARGUMENTS="$(config_get args)"
  export KEEPALIVED_STATE="$(config_get state)"
}

# Run upstream entrypoint
exec /container/tool/run
