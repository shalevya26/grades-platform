#!/usr/bin/env bash
# Commits what changed and pushes it, retrying when someone else pushed first:
#
#   scripts/commit-push.sh "chore: deploy grades-api 1.2.0 to staging" main
set -euo pipefail

message="${1:?usage: scripts/commit-push.sh <message> [branch]}"
branch="${2:-main}"
tries="${MAX_TRIES:-5}"

if git diff --quiet; then
  echo "No changes to commit."
  exit 0
fi

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add -A
git commit -q -m "$message"

for attempt in $(seq 1 "$tries"); do
  git fetch -q origin "$branch"
  if ! git rebase -q "origin/$branch"; then
    git rebase --abort
    echo "Rebase failed (a conflict); trying again from the start."
  fi
  if git push -q origin "HEAD:$branch"; then
    echo "Pushed on attempt $attempt."
    exit 0
  fi
  delay=$(( 2 ** attempt + RANDOM % 3 ))
  echo "Push failed (attempt $attempt). Next try in ${delay}s."
  sleep "$delay"
done
echo "Gave up after $tries attempts." >&2
exit 1
