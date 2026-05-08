#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="${RUN_DIR:-/tmp/openclaw-lab-local-https}"

if [[ -d "$RUN_DIR/portforwards" ]]; then
  for pid_file in "$RUN_DIR"/portforwards/*.pid; do
    [[ -e "$pid_file" ]] || continue
    pid="$(cat "$pid_file")"
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid"
    fi
    rm -f "$pid_file"
  done
fi

SERVER_PID_FILE="$RUN_DIR/http-server.pid"
if [[ -s "$SERVER_PID_FILE" ]]; then
  pid="$(cat "$SERVER_PID_FILE")"
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid"
  fi
  rm -f "$SERVER_PID_FILE"
fi

docker rm -f openclaw-lab-caddy >/dev/null 2>&1 || true
echo "Stopped local HTTPS access helpers."
