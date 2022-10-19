#!/usr/bin/env bash

set -euo pipefail

echo "::group::docker logs lyra95/postgres-bigm:${NEW_TAG}"
docker logs test
echo "::endgroup::"

echo "::group::docker inspect lyra95/postgres-bigm:${NEW_TAG}"
docker inspect test
echo "::endgroup::"
