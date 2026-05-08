# Cilium Monitor Flow Evidence

Date: 2026-05-08

The standalone `hubble` CLI is not installed on the lab host, so this evidence was captured with `cilium-dbg monitor` from the Cilium agent pods on the same nodes as the OpenClaw workloads. Hubble Relay and Hubble UI are running and healthy; this file records command-line Cilium policy/drop evidence until Hubble UI screenshots or Hubble CLI output are attached.

## Endpoint Map

Factory:

- Namespace: `openclaw-factory`
- Pod: `openclaw-factory-0`
- Pod IP: `10.244.4.178`
- Node: `openclaw-lab-worker3`
- Cilium pod: `cilium-qm8sq`
- Cilium endpoint ID: `778`

ACI:

- Namespace: `openclaw-aci`
- Pod: `openclaw-aci-0`
- Pod IP: `10.244.5.5`
- Node: `openclaw-lab-worker`
- Cilium pod: `cilium-hwcfb`
- Cilium endpoint ID: `1870`

## Allowed Egress Evidence

Probe result from `openclaw-aci`:

```text
openai 200
github 200
```

Cilium monitor evidence from endpoint `1870`:

```text
Policy verdict log: flow 0x71a33ed2 local EP ID 1870, remote ID 37156, proto 17, egress, action redirect, auth: disabled, match L3-L4, 10.244.5.5:59873 -> 10.244.1.63:53 udp
Policy verdict log: flow 0xd352d9ee local EP ID 1870, remote ID 16777231, proto 6, egress, action allow, auth: disabled, match L4-Only, 10.244.5.5:57924 -> 162.159.140.245:443 tcp SYN
Policy verdict log: flow 0x95844764 local EP ID 1870, remote ID 16777233, proto 6, egress, action allow, auth: disabled, match L4-Only, 10.244.5.5:58220 -> 140.82.112.5:443 tcp SYN
```

Interpretation:

- DNS egress is redirected through Cilium DNS handling.
- HTTPS egress is allowed for resolved FQDN destinations covered by policy.
- The command-level probe confirms the provider endpoints returned HTTP `200` without recording API keys or response bodies.

## Denied Egress Evidence

Factory denied probe results:

```text
169.254.169.254 TimeoutError
100.100.100.200 TimeoutError
```

Factory Cilium monitor evidence from endpoint `778`:

```text
Policy verdict log: flow 0x498bddf0 local EP ID 778, remote ID 16777217, proto 6, egress, action deny, auth: disabled, match L3-Only, 10.244.4.178:60220 -> 169.254.169.254:80 tcp SYN
xx drop (Policy denied by denylist) flow 0x498bddf0 to endpoint 0, ifindex 21, file bpf_lxc.c:1651, , identity 4349->16777217: 10.244.4.178:60220 -> 169.254.169.254:80 tcp SYN
```

ACI denied probe results:

```text
169.254.169.254 TimeoutError
100.100.100.200 TimeoutError
```

ACI Cilium monitor evidence from endpoint `1870`:

```text
Policy verdict log: flow 0x5bf2e672 local EP ID 1870, remote ID 16777218, proto 6, egress, action deny, auth: disabled, match L3-Only, 10.244.5.5:52676 -> 169.254.169.254:80 tcp SYN
xx drop (Policy denied by denylist) flow 0x5bf2e672 to endpoint 0, ifindex 25, file bpf_lxc.c:1651, , identity 25917->16777218: 10.244.5.5:52676 -> 169.254.169.254:80 tcp SYN
Policy verdict log: flow 0x1c5243d9 local EP ID 1870, remote ID 16777217, proto 6, egress, action deny, auth: disabled, match L3-Only, 10.244.5.5:57304 -> 100.100.100.200:80 tcp SYN
xx drop (Policy denied by denylist) flow 0x1c5243d9 to endpoint 0, ifindex 25, file bpf_lxc.c:1651, , identity 25917->16777217: 10.244.5.5:57304 -> 100.100.100.200:80 tcp SYN
```

Interpretation:

- Metadata endpoint `169.254.169.254:80` is denied by Cilium policy.
- Tailscale DNS endpoint `100.100.100.200:80` is denied by Cilium policy.
- Application probes see timeouts, consistent with Cilium deny/drop behavior.

## Remaining Evidence Gap

Attach Hubble UI screenshots or standalone Hubble CLI output later for a UI-native record of the same flows.
