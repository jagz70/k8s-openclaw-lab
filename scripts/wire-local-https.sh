#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required for the temporary CA download server" >&2
  exit 1
fi

if ! command -v tailscale >/dev/null 2>&1; then
  echo "tailscale CLI is required to discover the rig IP" >&2
  exit 1
fi

RUN_DIR="${RUN_DIR:-/tmp/openclaw-lab-local-https}"
mkdir -p "$RUN_DIR"

"$script_dir/stop-tailscale-portforwards.sh" >/dev/null 2>&1 || true
"$script_dir/start-local-https.sh"
"$script_dir/export-local-https-ca.sh"

TS_IP="$(tailscale ip -4)"
HOSTS_FILE="$RUN_DIR/hosts-snippet.txt"
LAPTOP_SCRIPT="$RUN_DIR/laptop-setup.sh"

cat >"$HOSTS_FILE" <<EOF
${TS_IP} argocd.openclaw.test factory.openclaw.test aci.openclaw.test
EOF

cat >"$LAPTOP_SCRIPT" <<EOF
#!/usr/bin/env bash
set -euo pipefail

ROOT_CA="\${1:-./rootCA.pem}"

if [[ ! -s "\$ROOT_CA" ]]; then
  echo "missing root CA: \$ROOT_CA" >&2
  exit 1
fi

cat <<'HOSTS'
${TS_IP} argocd.openclaw.test factory.openclaw.test aci.openclaw.test
HOSTS

case "\$(uname -s)" in
  Darwin)
    sudo security add-trusted-cert -d -r trustRoot \
      -k /Library/Keychains/System.keychain "\$ROOT_CA"
    ;;
  Linux)
    sudo cp "\$ROOT_CA" /usr/local/share/ca-certificates/openclaw-lab-rootCA.crt
    sudo update-ca-certificates
    ;;
  *)
    echo "unsupported laptop OS: \$(uname -s)" >&2
    exit 1
    ;;
esac

echo
echo "Add this to your laptop hosts file if it is not already present:"
echo "${TS_IP} argocd.openclaw.test factory.openclaw.test aci.openclaw.test"
echo
echo "Then open:"
echo "  https://argocd.openclaw.test"
echo "  https://factory.openclaw.test"
echo "  https://aci.openclaw.test"
EOF

chmod +x "$LAPTOP_SCRIPT"

PORT=19090
SERVER_PID_FILE="$RUN_DIR/http-server.pid"
if [[ -s "$SERVER_PID_FILE" ]] && kill -0 "$(cat "$SERVER_PID_FILE")" 2>/dev/null; then
  kill "$(cat "$SERVER_PID_FILE")" 2>/dev/null || true
fi

setsid python3 -m http.server "$PORT" --bind "$TS_IP" --directory "$RUN_DIR" \
  >"$RUN_DIR/http-server.log" 2>&1 < /dev/null &
echo "$!" > "$SERVER_PID_FILE"

echo
echo "Wire-up artifacts:"
echo "  CA download:      http://${TS_IP}:${PORT}/rootCA.pem"
echo "  Laptop helper:    http://${TS_IP}:${PORT}/laptop-setup.sh"
echo "  Hosts snippet:    http://${TS_IP}:${PORT}/hosts-snippet.txt"
echo
echo "On the laptop:"
echo "  curl -fsSLO http://${TS_IP}:${PORT}/rootCA.pem"
echo "  curl -fsSLO http://${TS_IP}:${PORT}/laptop-setup.sh"
echo "  chmod +x laptop-setup.sh"
echo "  ./laptop-setup.sh ./rootCA.pem"
echo
echo "Temporary file server pid: $(cat "$SERVER_PID_FILE")"
