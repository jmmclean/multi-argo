#!/usr/bin/env bash
if [ "minikube" != "$(kubectl config current-context)" ]; then
    echo "[ERROR] current kubeconfig context is not minikube"
    exit 1
fi

kubectl patch application minikube-apps -n argo-cd-ops --patch '{"spec": {"source": {"targetRevision": "break-it"}}}'
