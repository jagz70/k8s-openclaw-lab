#!/usr/bin/env bash
set -euo pipefail

arch="$(dpkg --print-architecture)"
case "${arch}" in
  amd64) go_arch="amd64" ;;
  arm64) go_arch="arm64" ;;
  *) echo "unsupported architecture: ${arch}" >&2; exit 1 ;;
esac

kind_version="${KIND_VERSION:-v0.31.0}"
kubectl_version="${KUBECTL_VERSION:-v1.35.4}"
helm_version="${HELM_VERSION:-v4.1.4}"
cilium_cli_version="${CILIUM_CLI_VERSION:-v0.18.9}"

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

docker_source="/etc/apt/sources.list.d/docker.list"
echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee "${docker_source}" >/dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

curl -fsSLo /tmp/kind "https://kind.sigs.k8s.io/dl/${kind_version}/kind-linux-${go_arch}"
sudo install -m 0755 /tmp/kind /usr/local/bin/kind

curl -fsSLo /tmp/kubectl "https://dl.k8s.io/release/${kubectl_version}/bin/linux/${go_arch}/kubectl"
sudo install -m 0755 /tmp/kubectl /usr/local/bin/kubectl

curl -fsSLo /tmp/helm.tar.gz "https://get.helm.sh/helm-${helm_version}-linux-${go_arch}.tar.gz"
tar -xzf /tmp/helm.tar.gz -C /tmp
sudo install -m 0755 "/tmp/linux-${go_arch}/helm" /usr/local/bin/helm

curl -fsSLo /tmp/cilium.tar.gz "https://github.com/cilium/cilium-cli/releases/download/${cilium_cli_version}/cilium-linux-${go_arch}.tar.gz"
tar -xzf /tmp/cilium.tar.gz -C /tmp cilium
sudo install -m 0755 /tmp/cilium /usr/local/bin/cilium

target_user="${SUDO_USER:-${USER}}"
sudo usermod -aG docker "${target_user}"

echo "Installed prerequisites."
echo "Log out and back in, or run: newgrp docker"
echo "Then re-run: ./scripts/check-prereqs.sh"
