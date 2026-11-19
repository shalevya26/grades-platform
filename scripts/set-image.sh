#!/usr/bin/env bash
# Sets the image of one service in one environment:
#
#   scripts/set-image.sh staging services/python/grades-api ghcr.io/me/grades-api:1.2.0-0003-gabc1234
#
# Only the line that ends with the marker "# <environment>_<service>" changes.
set -euo pipefail

environment="${1:?usage: scripts/set-image.sh <environment> <service> <image>}"
service="${2:?usage: scripts/set-image.sh <environment> <service> <image>}"
image="${3:?usage: scripts/set-image.sh <environment> <service> <image>}"
file="deploy/${environment}/apps.yaml"
marker="# ${environment}_${service}"

tmp=$(mktemp)
# A line counts only if it ends with the whole marker (grades-ap is not grades-api)
if ! awk -v marker="$marker" -v image="$image" '
  { tail = substr($0, length($0) - length(marker) + 1) }
  tail == marker { sub(/image: [^ ]+/, "image: " image); found++ }
  { print }
  END { exit found ? 0 : 1 }' "$file" > "$tmp"; then
  rm -f "$tmp"
  echo "no line ends with '$marker' in $file" >&2
  exit 1
fi
mv "$tmp" "$file"
echo "$file: $service -> $image"
