#!/usr/bin/env bash
# The version of one service, read from its release tags (<service>@X.Y.Z).
#
#   scripts/version.sh services/python/grades-api              1.2.0             (on the tag)
#                                                              1.2.0-3-gabc1234  (3 commits after it)
#   scripts/version.sh services/python/grades-api --extended   1.2.0-0003-gabc1234
#
# No release tag yet? Then the base is 0.0.0 and the count is every commit.
# The CI needs the whole history for this: actions/checkout with fetch-depth: 0.
set -euo pipefail

service="${1:?usage: scripts/version.sh <service path> [--extended]}"
mode="${2:-}"

pattern="${service}@[0-9]*.[0-9]*.[0-9]*"
if desc=$(git describe --tags --first-parent --match "$pattern" 2> /dev/null)
then
  desc="${desc#"${service}@"}"
else
  count=$(git rev-list --count --first-parent HEAD)
  desc="0.0.0-${count}-g$(git rev-parse --short HEAD)"
fi

if [[ "$mode" == "--extended" ]]; then
  # Always X.Y.Z-NNNN-g<sha>: four digits, so the tags also sort as text
  if [[ ! "$desc" =~ -g[0-9a-f]+$ ]]; then
    desc="${desc}-0-g$(git rev-parse --short HEAD)"
  fi
  IFS='-' read -r base count ref <<< "$desc"
  printf '%s-%04d-%s\n' "$base" "$count" "$ref"
else
  echo "$desc"
fi
