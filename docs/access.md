# Local Access

Services are private `ClusterIP` services. Use `kubectl port-forward` from the lab host and retrieve runtime credentials directly from Kubernetes Secrets when needed.

## Argo CD

Forward the Argo CD API/UI:

```bash
kubectl -n argocd port-forward svc/argocd-server 18080:80
```

Open:

```text
http://localhost:18080
```

Initial username:

```text
admin
```

Read the initial admin password from the cluster:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo
```

## OpenClaw Factory

Forward the factory gateway:

```bash
kubectl -n openclaw-factory port-forward svc/openclaw-factory 18789:18789
```

Open:

```text
http://localhost:18789
```

Read the generated gateway token:

```bash
kubectl -n openclaw-factory get secret openclaw-factory-gateway-token \
  -o jsonpath='{.data.token}' | base64 -d; echo
```

## OpenClaw ACI Specialist

Forward the ACI gateway:

```bash
kubectl -n openclaw-aci port-forward svc/openclaw-aci 18790:18789
```

Open:

```text
http://localhost:18790
```

Read the generated gateway token:

```bash
kubectl -n openclaw-aci get secret openclaw-aci-gateway-token \
  -o jsonpath='{.data.token}' | base64 -d; echo
```

## Canvas Ports

The OpenClaw services also expose canvas on service port `18793`. Forward it only when needed:

```bash
kubectl -n openclaw-factory port-forward svc/openclaw-factory 18793:18793
kubectl -n openclaw-aci port-forward svc/openclaw-aci 18794:18793
```
