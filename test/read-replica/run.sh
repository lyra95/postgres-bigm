#!/usr/bin/env bash

readonly RESOURCES=(statefulset/test-postgresql-primary statefulset/test-postgresql-read)

set -euo pipefail

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install test bitnami/postgresql -f test/read-replica/values.yaml --set image.tag="${NEW_TAG}"

for RESOURCE in "${RESOURCES[@]}"; do
  kubectl rollout status "$RESOURCE" --timeout=3m
done;

kubectl exec test-postgresql-primary-0 -- /bin/bash -c 'PGPASSWORD=1234 psql -U postgres -w -c '\''\dx'\''' | grep -q pg_bigm
kubectl exec test-postgresql-read-0 -- /bin/bash -c 'PGPASSWORD=1234 psql -U postgres -w -c '\''\dx'\''' | grep -q pg_bigm
kubectl exec test-postgresql-read-1 -- /bin/bash -c 'PGPASSWORD=1234 psql -U postgres -w -c '\''\dx'\''' | grep -q pg_bigm
