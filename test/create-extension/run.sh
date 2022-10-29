#!/usr/bin/env bash

set -euo pipefail

docker run --name test -dp 5432 \
  -e POSTGRESQL_PASSWORD=1234 \
  -e POSTGRES_PASSWORD=1234 \
  -e POSTGRESQL_SHARED_PRELOAD_LIBRARIES=pgaudit,pg_bigm \
  --pull never \
  "lyra95/postgres-bigm:${NEW_TAG}"

# sleep until stabilized
sleep 5

docker exec -e PGPASSWORD=1234 test psql --username=postgres --no-password --dbname=postgres -c "CREATE EXTENSION pg_bigm;"
docker exec -e PGPASSWORD=1234 test psql --username=postgres --no-password --dbname=postgres -c "\dx" | grep -q pg_bigm
