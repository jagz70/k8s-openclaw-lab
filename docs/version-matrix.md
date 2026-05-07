# Version Matrix

Pin versions before applying to a live cluster.

| Component | Version | Notes |
|---|---:|---|
| kind | `v0.31.0` | Latest observed kind release during setup. |
| Kubernetes kind node image | `kindest/node:v1.34.3@sha256:08497ee19eace7b4b5348db5c6a1591d7752b164530a36f855cb0f2bdcbadd48` | Digest pinned from kind `v0.31.0`; chosen over 1.35.0 after control-plane join failure. |
| kubectl | `v1.35.4` | Client is one minor ahead of the Kubernetes 1.34 lab control plane, which is supported. |
| Cilium | `1.19.3` | Latest stable observed during planning. Verify before install. |
| Cilium CLI | `v0.18.9` | Latest observed Cilium CLI release. |
| Helm | `v4.1.4` | Latest observed Helm release. |
| Argo CD | `8.0.0` | Helm chart version placeholder. Verify before install. |
| OpenClaw Operator | `0.28.0` | Latest observed release during planning. Verify chart/install path before install. |
