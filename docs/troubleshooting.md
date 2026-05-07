# Troubleshooting

## kind control-plane join failed on Kubernetes 1.35

Initial 11-node bootstrap used:

```text
kindest/node:v1.35.0@sha256:452d707d4862f52530247495d180205e029056831160e22870e37e3f6c1ac31f
```

The cluster failed while joining the third control-plane node with `kubeadm join`. The output included kubeadm `v1beta3` deprecation warnings on Kubernetes 1.35.

Previous mitigation:

- scale the lab down to 3 control-plane nodes and 5 workers
- use kind's published Kubernetes 1.34.3 image from kind `v0.31.0`

## kind etcd learner promotion failed on Kubernetes 1.34.3

On this host, the 3-control-plane topology repeatedly failed while joining the
third control-plane node. `kubeadm join` waited for the new etcd learner to
sync and eventually failed with:

```text
etcdserver: can only promote a learner member which is in sync with leader
```

Current host-specific mitigation:

- use a single control-plane node and 5 workers for the local lab
- keep `disableDefaultCNI: true` and `kubeProxyMode: none` for Cilium validation

Current pinned image:

```text
kindest/node:v1.34.3@sha256:08497ee19eace7b4b5348db5c6a1591d7752b164530a36f855cb0f2bdcbadd48
```
