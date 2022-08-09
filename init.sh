#!/usr/bin/env bash
if [ "minikube" != "$(kubectl config current-context)" ]; then
    echo "[ERROR] current kubeconfig context is not minikube"
    exit 1
fi
