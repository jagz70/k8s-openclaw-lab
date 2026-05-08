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

## Command-Line Flow Evidence

See `cilium-monitor-flow-evidence-2026-05-08.md` for Cilium monitor evidence showing:

- DNS egress redirected through Cilium DNS handling.
- HTTPS egress allowed for provider endpoints.
- `169.254.169.254:80` denied and dropped by policy.
- `100.100.100.200:80` denied and dropped by policy.

## Next Evidence To Capture

- Hubble UI screenshots or standalone Hubble CLI output for allowed DNS and HTTPS egress to `api.openai.com`.
- Hubble UI screenshots or standalone Hubble CLI output for allowed HTTPS egress to `api.github.com`.
- Hubble UI screenshots or standalone Hubble CLI output for drop/deny flows to `169.254.169.254`.
- Hubble UI screenshots or standalone Hubble CLI output for drop/deny flows to `100.100.100.200`.
