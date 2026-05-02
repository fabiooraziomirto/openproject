#!/usr/bin/env bash
# Push the custom image to ghcr.io.
# Requires GITHUB_TOKEN env var with write:packages scope.
# Usage: ./scripts/push.sh [VERSION]

set -euo pipefail

REGISTRY="ghcr.io"
IMAGE="fabiooraziomirto/openproject"
VERSION="${1:-1.0.0}"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Error: GITHUB_TOKEN environment variable is not set."
  exit 1
fi

echo "${GITHUB_TOKEN}" | docker login "${REGISTRY}" -u fabiooraziomirto --password-stdin

docker push "${REGISTRY}/${IMAGE}:${VERSION}"
docker push "${REGISTRY}/${IMAGE}:latest"

echo "Pushed ${REGISTRY}/${IMAGE}:${VERSION}"
