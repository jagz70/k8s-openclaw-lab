# Tailscale Access

Use these commands when testing the lab UI from a laptop on the same Tailscale network.

## Start Forwards

On the lab rig:

```bash
./scripts/start-tailscale-portforwards.sh
```

The script starts localhost-only Kubernetes port-forwards for Tailscale Serve to proxy.

Current URLs on this rig:

```text
Argo CD:           https://k8s-openclaw-rig.taild480a.ts.net:18080
OpenClaw Factory:  https://k8s-openclaw-rig.taild480a.ts.net:18789
OpenClaw ACI:      https://k8s-openclaw-rig.taild480a.ts.net:18790
```

## Enable HTTPS

Tailscale Serve configuration requires root/operator permissions on the rig:

```bash
sudo tailscale serve --bg --https 18080 http://127.0.0.1:18080
sudo tailscale serve --bg --https 18789 http://127.0.0.1:18789
sudo tailscale serve --bg --https 18790 http://127.0.0.1:18790
```

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
sudo tailscale serve reset
```
