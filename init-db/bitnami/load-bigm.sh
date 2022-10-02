#!/usr/bin/env bash

set -euo pipefail

CONF_PATH=$(psql --no-password -tU postgres -c 'SHOW config_file')

if [ -z "$CONF_PATH" ]; then
	exit 1
fi

mkdir -p "$(dirname "$CONF_PATH")" && echo shared_preload_libraries = 'pg_bigm' >> "$CONF_PATH"
