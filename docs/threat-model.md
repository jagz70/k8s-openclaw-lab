# Threat Model

## Primary Risks

- Agent gets unrestricted egress.
- Agent receives cluster-admin or broad Kubernetes write access.
- Secrets are committed to Git.
- Specialist can access another specialist namespace or memory.
- ACI specialist receives production APIC write access.
- Cloud metadata endpoints are reachable from pods.

## Controls

- Namespaced `OpenClawInstance` resources.
- Minimal service accounts and RBAC.
- Cilium default-deny ingress and egress.
- Explicit allow rules for DNS, Git, approved LLM endpoint, and required internal sources.
- Hubble flow review before promotion.
- Human review of every factory-generated PR.
