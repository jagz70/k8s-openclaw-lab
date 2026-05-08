#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="${RUN_DIR:-/tmp/openclaw-lab-portforwards}"

if [[ ! -d "$RUN_DIR" ]]; then
  echo "No port-forward run directory found: $RUN_DIR"
  exit 0
fi

for pid_file in "$RUN_DIR"/*.pid; do
  [[ -e "$pid_file" ]] || continue
  name="$(basename "$pid_file" .pid)"
  pid="$(cat "$pid_file")"

  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid"
    echo "$name stopped: pid $pid"
  else
    echo "$name was not running: pid $pid"
  fi

  rm -f "$pid_file"
done
