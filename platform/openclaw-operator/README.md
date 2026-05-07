# OpenClaw Operator

This directory contains the pinned OpenClaw Operator install path.

The documented install source is:

```text
oci://ghcr.io/openclaw-rocks/charts/openclaw-operator
```

Before applying to anything beyond the lab:

1. Confirm the chart version.
2. Review controller RBAC.
3. Confirm the CRD schema for the target `OpenClawInstance` version.
4. Keep webhook, backup, and advanced integrations disabled unless explicitly needed.
