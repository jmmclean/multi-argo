#!/usr/bin/env bash
if [ "minikube" != "$(kubectl config current-context)" ]; then
    echo "[ERROR] current kubeconfig context is not minikube"
    exit 1
fi

# Create Namespaces
kubectl create namespace argo-cd-dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argo-cd-staging --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argo-cd-prod --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argo-cd-ops --dry-run=client -o yaml | kubectl apply -f -

# Install CRD
kustomize build --load-restrictor LoadRestrictionsNone --enable-helm argo-cd-crd | kubectl apply -f -

# Install Argo
kustomize build --load-restrictor LoadRestrictionsNone --enable-helm argo-cd/dev/minikube | kubectl apply -f -
kustomize build --load-restrictor LoadRestrictionsNone --enable-helm argo-cd/staging/minikube | kubectl apply -f -
kustomize build --load-restrictor LoadRestrictionsNone --enable-helm argo-cd/prod/minikube | kubectl apply -f -
kustomize build --load-restrictor LoadRestrictionsNone --enable-helm argo-cd/ops/minikube | kubectl apply -f -

# Apply Clust RBAC
kustomize build --load-restrictor LoadRestrictionsNone --enable-helm argo-cd-cluster-rbac | kubectl apply -f -

# Apply App of Apps
kubectl apply -f apps/dev/minikube/application.yml
kubectl apply -f apps/staging/minikube/application.yml
kubectl apply -f apps/prod/minikube/application.yml
kubectl apply -f apps/ops/minikube/application.yml
