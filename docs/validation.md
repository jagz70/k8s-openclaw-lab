# Validation

This file records non-secret smoke tests for the local lab.

## 2026-05-08

Cluster and GitOps:

- Argo CD root app is `Synced` and `Healthy`.
- `openclaw-factory` app is `Synced` and `Healthy`.
- `openclaw-aci` app is `Synced` and `Healthy`.
- Cilium, Cilium Operator, Envoy, Hubble Relay, and Hubble UI report `OK`.

OpenClaw workloads:

- `openclaw-factory` is `Running`, `Ready=True`; pod is `3/3 Running`.
- `openclaw-aci` is `Running`, `Ready=True`; pod is `3/3 Running`.
- Both services have endpoints through the gateway proxy.
- Both gateways return HTTP `200` for `/`, `/healthz`, and `/readyz`.
- The canvas route `/__openclaw__/canvas/` returns HTTP `401` without auth, as expected.

Workspace seed files:

- `AGENTS.md`, `MEMORY.md`, `SOUL.md`, `HEARTBEAT.md`, and `ENVIRONMENT.md` are present in both instance workspaces.
- `BOOTSTRAP.md` is present in the generated workspace ConfigMaps but is no longer present on disk after startup. OpenClaw created persistent identity/user/tool files, so the bootstrap path appears to have run.

Network and API egress:

- `api.openai.com` returned HTTP `200` from both instances using the runtime `OPENAI_API_KEY`.
- `api.github.com` returned HTTP `200` from both instances.
- TCP probes to `169.254.169.254:80` timed out from both instances.
- TCP probes to `100.100.100.200:80` timed out from both instances.

Local access:

- `kubectl -n argocd port-forward svc/argocd-server 18080:80` returned HTTP `200` at `http://127.0.0.1:18080`.
- `kubectl -n openclaw-factory port-forward svc/openclaw-factory 18789:18789` returned HTTP `200` at `http://127.0.0.1:18789/healthz`.
- `kubectl -n openclaw-aci port-forward svc/openclaw-aci 18790:18789` returned HTTP `200` at `http://127.0.0.1:18790/healthz`.

Persistence:

- A non-secret `PERSISTENCE_CHECK.md` marker written to the factory workspace survived deletion and recreation of `pod/openclaw-factory-0`.
- A non-secret `PERSISTENCE_CHECK.md` marker written to the ACI workspace survived deletion and recreation of `pod/openclaw-aci-0`.
- Both PVCs remained `Bound` and both pods returned to `3/3 Running`.

Notes:

- The standalone `hubble` CLI is not installed on the host. Hubble Relay and UI are running, so flow evidence can be collected through Hubble UI or by installing the CLI later.
