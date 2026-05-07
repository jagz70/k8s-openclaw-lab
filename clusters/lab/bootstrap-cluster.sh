#!/usr/bin/env bash
set -euo pipefail

cluster_name="openclaw-lab"
config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kind get clusters | grep -qx "${cluster_name}" && {
  echo "kind cluster ${cluster_name} already exists"
  exit 0
}

kind create cluster --config "${config_dir}/kind-config.yaml"
kubectl cluster-info --context "kind-${cluster_name}"
