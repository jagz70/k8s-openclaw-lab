#!/usr/bin/env bash
set -euo pipefail

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update argo

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --version "${ARGOCD_CHART_VERSION:-8.0.0}" \
  --values platform/argocd/values.yaml

kubectl -n argocd rollout status deployment/argocd-server
