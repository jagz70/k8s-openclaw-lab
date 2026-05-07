# OpenClaw Lab

Docker-backed Kubernetes lab for OpenClaw instances contained by Cilium and managed through GitOps.

## Target

- kind cluster with 1 control-plane node and 5 workers
- Cilium as the only CNI
- Hubble enabled for flow evidence
- Argo CD for GitOps
- OpenClaw Operator for `OpenClawInstance` resources
- `openclaw-factory` first, then `openclaw-aci`

## Bootstrap Order

1. Create the kind cluster with the default CNI disabled.
2. Install Cilium and enable Hubble.
3. Install Argo CD.
4. Install OpenClaw Operator.
5. Apply the GitOps root applications.
6. Create runtime secrets manually, outside Git.
7. Deploy `openclaw-factory`.
8. Deploy `openclaw-aci`.

## Secrets

Do not commit API keys or tokens. Use the templates in `secrets/` only as examples.

Create the OpenAI secret manually after revoking the exposed key and creating a new one:

```bash
kubectl create namespace openclaw-factory --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic openai-api \
  -n openclaw-factory \
  --from-literal=OPENAI_API_KEY='replace-with-new-key'
```

Repeat in specialist namespaces only when a specialist needs direct LLM access.

## Local Commands

```bash
./clusters/lab/bootstrap-cluster.sh
./clusters/lab/install-cilium.sh
./clusters/lab/install-argocd.sh
./clusters/lab/install-openclaw-operator.sh
```

The scripts are intentionally small and inspectable. They assume `docker`, `kind`, `kubectl`, `helm`, and the `cilium` CLI are installed.

For host setup on this machine, see `docs/host-prep.md`.
