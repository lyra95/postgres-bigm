#!/usr/bin/env bash
set -euo pipefail

readonly TAGS=('13' '14.5.0' '14.5.0-debian-11-r15')

for TAG in "${TAGS[@]}"; do
    docker build --build-arg IMAGE_BASE="bitnami/postgresql:$TAG" -f Dockerfile . -t "lyra95/postgres-bigm:$TAG"
done

for TAG in "${TAGS[@]}"; do
    docker push "lyra95/postgres-bigm:$TAG"
done
