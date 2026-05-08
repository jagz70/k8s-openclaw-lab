# Decisions

## Day-One Defaults

| Area | Decision |
|---|---|
| Cluster runtime | kind |
| Cluster topology | 3 control-plane nodes, 5 workers |
| CNI | Cilium |
| Observability | Hubble |
| GitOps | Argo CD |
| OpenClaw install | OpenClaw Operator |
| Secrets | Manual Kubernetes Secrets, excluded from Git |
| Laptop access | Caddy reverse proxy with its local CA and distinct hostnames |
| LLM provider | OpenAI API through Kubernetes Secret |
| QMD | Workstation-only first |
| First specialist | openclaw-aci |
| Persona | Professional for specialists, slightly more conversational for factory |

## Deferred

- Istio
- Vault
- Crossplane
- External Secrets
- service mesh
- advanced policy engines
- production APIC write access
- self-mutating agents with Kubernetes write access
