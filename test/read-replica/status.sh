#!/usr/bin/env bash

set -euo pipefail

echo "::group::kubectl get:primary"
kubectl get statefulset/test-postgresql-primary -o yaml
echo "::endgroup::"

echo "::group::kubectl describe:primary"
kubectl describe statefulset/test-postgresql-primary
echo "::endgroup::"

echo "::group::kubectl logs:primary"
kubectl logs statefulset/test-postgresql-primary
echo "::endgroup::"

echo "::installed extensions:primary"
kubectl exec test-postgresql-primary-0 -- /bin/bash -c 'PGPASSWORD=1234 psql -U postgres -w -c '\''\dx'\'''
echo "::endgroup::"

echo "::group::kubectl get:read"
kubectl get statefulset/test-postgresql-read -o yaml
echo "::endgroup::"

echo "::group::kubectl describe:read"
kubectl describe statefulset/test-postgresql-read
echo "::endgroup::"

echo "::group::kubectl logs:read"
kubectl logs statefulset/test-postgresql-read
echo "::endgroup::"

echo "::installed extensions:read"
kubectl exec test-postgresql-read-0 -- /bin/bash -c 'PGPASSWORD=1234 psql -U postgres -w -c '\''\dx'\'''
kubectl exec test-postgresql-read-1 -- /bin/bash -c 'PGPASSWORD=1234 psql -U postgres -w -c '\''\dx'\'''
echo "::endgroup::"
