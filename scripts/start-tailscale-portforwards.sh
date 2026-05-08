#!/usr/bin/env bash
set -euo pipefail

if ! command -v tailscale >/dev/null 2>&1; then
  echo "tailscale CLI is required" >&2
  exit 1
fi

TAILSCALE_IP="${TAILSCALE_IP:-$(tailscale ip -4 | head -n 1)}"
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

start_forward argocd -n argocd port-forward --address "$TAILSCALE_IP" svc/argocd-server 18080:80
start_forward factory-gateway -n openclaw-factory port-forward --address "$TAILSCALE_IP" svc/openclaw-factory 18789:18789
start_forward aci-gateway -n openclaw-aci port-forward --address "$TAILSCALE_IP" svc/openclaw-aci 18790:18789

sleep 1

echo
echo "Tailscale URLs:"
echo "  Argo CD:           http://$TAILSCALE_IP:18080"
echo "  OpenClaw Factory:  http://$TAILSCALE_IP:18789"
echo "  OpenClaw ACI:      http://$TAILSCALE_IP:18790"
echo
echo "Logs: $RUN_DIR"
