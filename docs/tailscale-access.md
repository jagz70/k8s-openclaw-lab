# Tailscale Access

Use these commands when testing the lab UI from a laptop on the same Tailscale network.

## Start Forwards

On the lab rig:

```bash
./scripts/start-tailscale-portforwards.sh
```

The script starts localhost-only Kubernetes port-forwards for Tailscale Serve to proxy.

Preferred URLs:

```text
Argo CD:           https://argocd.taild480a.ts.net
OpenClaw Factory:  https://openclaw-factory.taild480a.ts.net
OpenClaw ACI:      https://openclaw-aci.taild480a.ts.net
```

Use separate hostnames for Factory and ACI. Do not use different ports on the same hostname for both OpenClaw instances; browser cookies are scoped by hostname and can cause gateway token collisions.

## Enable HTTPS

Tailscale Serve configuration requires root/operator permissions on the rig:

```bash
sudo tailscale serve --bg --service=svc:argocd --https=443 http://127.0.0.1:18080
sudo tailscale serve --bg --service=svc:openclaw-factory --https=443 http://127.0.0.1:18789
sudo tailscale serve --bg --service=svc:openclaw-aci --https=443 http://127.0.0.1:18790
```

Tailscale Services may require approval in the Tailscale admin console before their MagicDNS names become reachable.

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
sudo tailscale serve --service=svc:argocd --https=443 off
sudo tailscale serve --service=svc:openclaw-factory --https=443 off
sudo tailscale serve --service=svc:openclaw-aci --https=443 off
```
