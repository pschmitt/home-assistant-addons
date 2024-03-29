#!/usr/bin/env bash

current_version() {
  jq -er .version ./config.json
}

latest_version() {
  curl -fsSL "https://api.github.com/repos/tailscale/tailscale/releases/latest" | \
    jq -er '.tag_name | sub("^v"; "")'
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  set -eo pipefail

  VERSION="${1:-$(latest_version)}"

  if [[ -z "$VERSION" ]]
  then
    echo "Missing version number" >&2
    exit 2
  fi

  cd "$(cd "$(dirname "$0")" >/dev/null 2>&1; pwd -P)" || exit 9

  CURRENT_VERSION="$(current_version)"

  if [[ "$CURRENT_VERSION" == "$VERSION" ]]
  then
    echo "Version is already $VERSION" >&2
    exit 1
  fi

  TMPFILE="$(mktemp)"

  # patch build.json
  jq -er --arg v "$VERSION" '.args.TAILSCALE_VERSION = $v' build.json > "$TMPFILE"
  mv "$TMPFILE" build.json

  # patch config.json
  jq -er --arg v "$VERSION" '.version = $v' config.json > "$TMPFILE"
  mv "$TMPFILE" config.json

  # Update changelog
  cat > "$TMPFILE" <<EOF
  # $VERSION
  - Update tailscale to $VERSION

EOF
  cat ./CHANGELOG.md >> "$TMPFILE"
  mv "$TMPFILE" ./CHANGELOG.md

  git status
  git add build.json config.json CHANGELOG.md
  git diff --cached
fi
