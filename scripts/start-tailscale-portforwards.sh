#!/usr/bin/env bash
set -euo pipefail

if ! command -v tailscale >/dev/null 2>&1; then
  echo "tailscale CLI is required" >&2
  exit 1
fi

TAILSCALE_DNS="${TAILSCALE_DNS:-$(tailscale status --json | sed -n 's/.*"DNSName": "\([^"]*\)".*/\1/p' | head -n 1 | sed 's/[.]$//')}"
RUN_DIR="${RUN_DIR:-/tmp/openclaw-lab-portforwards}"
mkdir -p "$RUN_DIR"

start_forward() {
  local name="$1"
  shift
  local pid_file="$RUN_DIR/$name.pid"
  local log_file="$RUN_DIR/$name.log"

  if [[ -s "$pid_file" ]] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
    echo "$name already running: pid $(cat "$pid_file")"
    return
  fi

  setsid kubectl "$@" >"$log_file" 2>&1 < /dev/null &
  echo "$!" > "$pid_file"
  echo "$name started: pid $(cat "$pid_file")"
}

start_forward argocd -n argocd port-forward --address 127.0.0.1 svc/argocd-server 18080:80
start_forward factory-gateway -n openclaw-factory port-forward --address 127.0.0.1 svc/openclaw-factory 18789:18789
start_forward aci-gateway -n openclaw-aci port-forward --address 127.0.0.1 svc/openclaw-aci 18790:18789

sleep 1

echo
echo "Tailscale HTTPS URLs:"
echo "  Argo CD:           https://$TAILSCALE_DNS:18080"
echo "  OpenClaw Factory:  https://$TAILSCALE_DNS:18789"
echo "  OpenClaw ACI:      https://$TAILSCALE_DNS:18790"
echo
echo "Logs: $RUN_DIR"
echo
echo "Enable HTTPS with:"
echo "  sudo tailscale serve --bg --https 18080 http://127.0.0.1:18080"
echo "  sudo tailscale serve --bg --https 18789 http://127.0.0.1:18789"
echo "  sudo tailscale serve --bg --https 18790 http://127.0.0.1:18790"
