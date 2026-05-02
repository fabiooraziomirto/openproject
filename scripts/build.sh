#!/usr/bin/env bash
# Build the custom OpenProject Docker image locally.
# Usage: ./scripts/build.sh [VERSION]
# Example: ./scripts/build.sh 1.0.0

set -euo pipefail

REGISTRY="ghcr.io"
IMAGE="fabiooraziomirto/openproject"
VERSION="${1:-1.0.0}"

echo "Building ${REGISTRY}/${IMAGE}:${VERSION} ..."

docker build \
  -f docker/Dockerfile \
  -t "${REGISTRY}/${IMAGE}:${VERSION}" \
  -t "${REGISTRY}/${IMAGE}:latest" \
  .

echo "Done: ${REGISTRY}/${IMAGE}:${VERSION}"
