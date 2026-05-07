#!/usr/bin/env bash
set -euo pipefail

operator_version="${OPENCLAW_OPERATOR_VERSION:-0.28.0}"

helm upgrade --install openclaw-operator \
  oci://ghcr.io/openclaw-rocks/charts/openclaw-operator \
  --namespace openclaw-operator-system \
  --create-namespace \
  --version "${operator_version}" \
  --values platform/openclaw-operator/values.yaml

kubectl wait --for=condition=Established crd/openclawinstances.openclaw.rocks --timeout=120s
kubectl -n openclaw-operator-system rollout status deployment/openclaw-operator
