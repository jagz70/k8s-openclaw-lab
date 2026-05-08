# Tailscale Access

Use these commands when testing the lab UI from a laptop on the same Tailscale network.

## Start Forwards

On the lab rig:

```bash
./scripts/start-tailscale-portforwards.sh
```

The script binds the port-forwards to the rig's Tailscale IPv4 address.

Current URLs:

```text
Argo CD:           http://100.76.12.60:18080
OpenClaw Factory:  http://100.76.12.60:18789
OpenClaw ACI:      http://100.76.12.60:18790
```

Use separate browser profiles or private windows if you need to avoid stale token cookies.

Check Serve status:

```bash
tailscale serve status
```

## Credentials

Read credentials from Kubernetes when needed. Do not paste them into Git or docs.

Argo CD:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo
```

OpenClaw Factory:

```bash
kubectl -n openclaw-factory get secret openclaw-factory-gateway-token \
  -o jsonpath='{.data.token}' | base64 -d; echo
```

OpenClaw ACI:

```bash
kubectl -n openclaw-aci get secret openclaw-aci-gateway-token \
  -o jsonpath='{.data.token}' | base64 -d; echo
```

## Stop Forwards

On the lab rig:

```bash
./scripts/stop-tailscale-portforwards.sh
```

Logs and PID files are stored under:

```text
/tmp/openclaw-lab-portforwards
```

To remove Tailscale Serve HTTPS configuration:

```bash
tailscale serve reset
```
