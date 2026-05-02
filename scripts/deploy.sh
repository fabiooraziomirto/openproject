#!/usr/bin/env bash
# Pull the latest image from ghcr.io and redeploy.
# Run from the repo root. Expects docker/deploy/.env to exist.
# Usage: ./scripts/deploy.sh [VERSION]

set -euo pipefail

DEPLOY_DIR="$(cd "$(dirname "$0")/../docker/deploy" && pwd)"
VERSION="${1:-}"

if [[ ! -f "${DEPLOY_DIR}/.env" ]]; then
  echo "Error: ${DEPLOY_DIR}/.env not found."
  echo "Copy docker/deploy/.env.example to docker/deploy/.env and fill in values."
  exit 1
fi

if [[ -n "${VERSION}" ]]; then
  export IMAGE_TAG="${VERSION}"
fi

cd "${DEPLOY_DIR}"

echo "Pulling latest image..."
docker compose pull

echo "Restarting services..."
docker compose up -d --remove-orphans

echo "Deployment complete."
docker compose ps
