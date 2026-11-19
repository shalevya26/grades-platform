#!/usr/bin/env bash
# The test of a static site: build the image, start it, ask for the page.
set -euo pipefail
name="grades-web-smoke-$$"
docker build -q -t grades-web:smoke . > /dev/null
docker run -d --rm --name "$name" -p 8081:80 grades-web:smoke > /dev/null
trap 'docker rm -f "$name" > /dev/null 2>&1 || true' EXIT
# wait until nginx answers: the first tries can be refused or reset while it starts
curl -fs --retry 10 --retry-delay 1 --retry-all-errors -o /dev/null http://localhost:8081/ \
  || { echo "grades-web did not answer on port 8081" >&2; exit 1; }
curl -fsS http://localhost:8081/ | grep -q "<title>grades-web</title>"
echo "grades-web: page ok, version $(curl -fsS http://localhost:8081/version.txt)"
