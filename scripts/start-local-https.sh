#!/usr/bin/env bash
set -euo pipefail

for bin in kubectl docker; do
  if ! command -v "${bin}" >/dev/null 2>&1; then
    echo "missing required command: ${bin}" >&2
    exit 1
  fi
done

if ! docker ps >/dev/null 2>&1; then
  echo "docker is not accessible in this shell. Open a fresh shell or run: newgrp docker" >&2
  exit 1
fi

RUN_DIR="${RUN_DIR:-/tmp/openclaw-lab-local-https}"
PF_DIR="$RUN_DIR/portforwards"
CADDY_DIR="$RUN_DIR/caddy"
mkdir -p "$PF_DIR" "$CADDY_DIR" "$RUN_DIR/caddy-data"

start_forward() {
  local name="$1"
  shift
  local pid_file="$PF_DIR/$name.pid"
  local log_file="$PF_DIR/$name.log"

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

cat >"$CADDY_DIR/Caddyfile" <<EOF
{
  admin off
}

argocd.openclaw.test {
  tls internal
  reverse_proxy 127.0.0.1:18080
}

factory.openclaw.test {
  tls internal
  reverse_proxy 127.0.0.1:18789
}

aci.openclaw.test {
  tls internal
  reverse_proxy 127.0.0.1:18790
}
EOF

docker rm -f openclaw-lab-caddy >/dev/null 2>&1 || true
docker run -d \
  --name openclaw-lab-caddy \
  --network host \
  -v "$CADDY_DIR/Caddyfile:/etc/caddy/Caddyfile:ro" \
  -v "$RUN_DIR/caddy-data:/data" \
  caddy:2 caddy run --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null

sleep 1

TS_IP="$(tailscale ip -4 2>/dev/null || true)"

echo
echo "Local HTTPS URLs:"
echo "  Argo CD:           https://argocd.openclaw.test"
echo "  OpenClaw Factory:  https://factory.openclaw.test"
echo "  OpenClaw ACI:      https://aci.openclaw.test"
echo
if [[ -n "$TS_IP" ]]; then
  echo "Add this to the laptop /etc/hosts file or local DNS:"
  echo "${TS_IP} argocd.openclaw.test factory.openclaw.test aci.openclaw.test"
  echo
fi
echo "Caddy root CA:"
echo "  $RUN_DIR/caddy-data/pki/authorities/local/root.crt"
echo "Export helper:"
echo "  ./scripts/export-local-https-ca.sh"
echo
echo "Logs: $RUN_DIR"
