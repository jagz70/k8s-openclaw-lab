#!/usr/bin/env bash
set -euo pipefail

cilium_version="${CILIUM_VERSION:-1.19.3}"
values_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../platform/cilium" && pwd)"

cilium install \
  --version "${cilium_version}" \
  --values "${values_dir}/values.yaml"

cilium status --wait
cilium hubble enable --ui
cilium status --wait
