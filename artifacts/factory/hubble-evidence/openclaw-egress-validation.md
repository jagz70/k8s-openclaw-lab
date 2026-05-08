# OpenClaw Egress Validation

Date: 2026-05-08

## Scope

Instances:

- `openclaw-factory`
- `openclaw-aci`

Policies:

- `instances/openclaw-factory/cilium-policy.yaml`
- `instances/specialists/openclaw-aci/cilium-policy.yaml`

## Positive Egress Checks

Both instances returned HTTP `200` for:

- `https://api.openai.com/v1/models` using the runtime `OPENAI_API_KEY`
- `https://api.github.com`

No API key or response body was recorded.

## Negative Egress Checks

TCP probes timed out from both instances for:

- `169.254.169.254:80`
- `100.100.100.200:80`

These probes match the intended `egressDeny` behavior in the Cilium policies.

## Hubble State

Cilium status reported:

- Cilium: `OK`
- Operator: `OK`
- Envoy DaemonSet: `OK`
- Hubble Relay: `OK`
- Hubble UI: `OK`

The standalone `hubble` CLI is not installed on the host. Flow screenshots or CLI output should be added after using Hubble UI or installing the CLI.

## Next Evidence To Capture

- Hubble flow for allowed DNS and HTTPS egress to `api.openai.com`.
- Hubble flow for allowed HTTPS egress to `api.github.com`.
- Hubble drop/deny flow for `169.254.169.254`.
- Hubble drop/deny flow for `100.100.100.200`.
