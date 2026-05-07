#!/usr/bin/env bash
set -euo pipefail

missing=0
for bin in docker kind kubectl helm cilium; do
  if ! command -v "${bin}" >/dev/null 2>&1; then
    echo "missing: ${bin}"
    missing=1
  else
    echo "found: ${bin} -> $(command -v "${bin}")"
  fi
done

exit "${missing}"
