#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="${RUN_DIR:-/tmp/openclaw-lab-local-https}"
mkdir -p "$RUN_DIR"

if ! docker cp openclaw-lab-caddy:/data/caddy/pki/authorities/local/root.crt "$RUN_DIR/rootCA.pem" >/dev/null 2>&1; then
  echo "Caddy root CA not available yet. Start the local HTTPS stack first." >&2
  exit 1
fi

chmod 0644 "$RUN_DIR/rootCA.pem"
echo "$RUN_DIR/rootCA.pem"
