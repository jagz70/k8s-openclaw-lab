# Host Prep

This host is Ubuntu 22.04 x86_64. The lab needs:

- Docker Engine
- kind
- kubectl
- Helm
- Cilium CLI

Run this locally from the repo root:

```bash
cd /home/jagz/openclaw-lab
sudo ./scripts/install-prereqs-ubuntu.sh
```

After installation, refresh Docker group membership:

```bash
newgrp docker
./scripts/check-prereqs.sh
```

If `docker` still requires sudo, log out and back in.

Then start the lab:

```bash
./clusters/lab/bootstrap-cluster.sh
./clusters/lab/install-cilium.sh
```
