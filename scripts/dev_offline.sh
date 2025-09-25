#!/usr/bin/env bash
set -euo pipefail

echo "[dev] Starting offline self-contained environment (SQLite, local storage)"

export DOCKER_DEFAULT_PLATFORM="${DOCKER_DEFAULT_PLATFORM:-linux/amd64}"

docker compose -f docker-compose.offline.yml build
docker compose -f docker-compose.offline.yml up -d

echo "[dev] Apply migrations"
docker compose -f docker-compose.offline.yml run --rm web python manage.py migrate --skip-checks

echo "[dev] If you need a superuser, run:\n  docker compose -f docker-compose.offline.yml run --rm web python manage.py createsuperuser"
echo "[dev] App is available at http://localhost:8000"
