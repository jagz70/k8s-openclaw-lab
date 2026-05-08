# Local HTTPS Access

Use this setup for laptop access without `ts.net`.

It keeps each app on its own hostname so browser state does not collide between Factory and ACI.

## On The Lab Rig

Install the host prerequisites, then start the local HTTPS stack:

```bash
./scripts/wire-local-https.sh
```

If you want the pieces separately:

```bash
./scripts/start-local-https.sh
```

The script starts:

```text
Argo CD:           https://argocd.openclaw.test
OpenClaw Factory:  https://factory.openclaw.test
OpenClaw ACI:      https://aci.openclaw.test
```

It also prints the current Tailscale IPv4 address so you can map those hostnames from your laptop.

If the launcher says Docker is not accessible, open a fresh shell or run `newgrp docker` first.

To export the Caddy root CA for trust on your laptop:

```bash
./scripts/export-local-https-ca.sh
```

That writes the root CA to:

```text
/tmp/openclaw-lab-local-https/rootCA.pem
```

## On The Laptop

Add the hostnames to your local hosts file or DNS using the rig's Tailscale IP.

Example entry:

```text
100.76.12.60 argocd.openclaw.test factory.openclaw.test aci.openclaw.test
```

Trust the exported `rootCA.pem`.

On macOS:

```bash
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain /path/to/rootCA.pem
```

On Ubuntu/Linux:

```bash
sudo cp /path/to/rootCA.pem /usr/local/share/ca-certificates/openclaw-lab-rootCA.crt
sudo update-ca-certificates
```

## Credentials

Read the runtime tokens from Kubernetes when needed. Do not commit them.

Argo CD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo
```

OpenClaw Factory token:

```bash
kubectl -n openclaw-factory get secret openclaw-factory-gateway-token \
  -o jsonpath='{.data.token}' | base64 -d; echo
```

OpenClaw ACI token:

```bash
kubectl -n openclaw-aci get secret openclaw-aci-gateway-token \
  -o jsonpath='{.data.token}' | base64 -d; echo
```

## Stop

```bash
./scripts/stop-local-https.sh
```

This stops the Kubernetes port-forwards, the Caddy container, and the temporary CA download server started by `wire-local-https.sh`.
