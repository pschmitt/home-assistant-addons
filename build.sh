#!/usr/bin/env bash

set -e

cd "$(readlink -f "$(dirname "$0")")" || exit 9

usage() {
  echo "Usage: $(basename "$0") ADDON [ARCH]"
}

addon_list() {
  local dir
  for dir in */config.json
  do
    dirname "$dir"
  done
}

addon_supports_arch() {
  if [[ "$(jq .arch "${1}/config.json")" == "null" ]]
  then
    return
  fi
  [[ $(jq ".arch|index(\"${2}\")" "${1}/config.json") != "null" ]]
}

addon_supported_arch() {
  # If arch is not set default to all
  if [[ $(jq .arch "${1}/config.json") == "null" ]]
  then
    echo "all"
    return
  fi
  jq -r ".arch|@tsv" "${1}/config.json"
}

build_addon() {
  local build_cmd
  local target
  local supported_arch

  build_cmd="docker run --rm --privileged \
    -v '/var/run/docker.sock:/var/run/docker.sock' \
    -v "${DOCKER_CONFIG:-${HOME}/.docker}:/root/.docker" \
    -v "${PWD}/${1}:/data" \
    ghcr.io/home-assistant/amd64-builder:latest \
    --addon -t /data"

  if [[ -n "$2" && "$2" != "all" ]]
  then
    target="$2"
    if ! addon_supports_arch "$1" "$target"
    then
      echo "Addon $1: No support for ARCH ${target}." 2>/dev/null
      exit 3
    fi
    eval "$build_cmd --$target"
  else
    target=all
    supported_arch=$(addon_supported_arch "$1")
    if [[ "$supported_arch" == "all" ]]
    then
      eval "$build_cmd --$target"
    else
      for target in $supported_arch
      do
        build_cmd="$build_cmd --$target"
      done
      eval "$build_cmd"
    fi
  fi
}

ADDONS=$(addon_list)

if [[ "$1" == all ]]
then
  for addon in $ADDONS
  do
    build_addon "$addon" "$2"
  done
elif [[ "$1" =~ "help" ]]
then
  usage
  exit 0
elif [[ -z "$1" ]]
then
  usage >&2
  exit 2
elif grep -q "$1" <<< "$ADDONS"
then
  build_addon "$1" "$2"
else
  echo "Unknown addon: $1"
  exit 2
fi

# vim: set ft=sh et ts=2 sw=2 :
