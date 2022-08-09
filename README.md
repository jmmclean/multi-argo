# multi-argo
This repository is meant to reproduce an error when multiple Argo's living on the same cluster (but are namespace scoped) will be crushed if the cluster-default secret is change to not have the `namespaces` defined.

## setup
1. Install `minikube`
    * https://minikube.sigs.k8s.io/docs/start/
2. run `minikube start`
3. execute `init.sh`

At this point, there should be 4 Argo's alive in the below namespaces:
* argo-cd-dev
* argo-cd-staging
* argo-cd-prod
* argo-cd-ops

this can be validated by running `kubectl get pods --all-namespaces`

## how to break it
To see argo delete all the other argo instances living on the same cluster, execute the `break-it.sh` script.

all the script does is apply a new app of apps application which is referencing the `break-it` branch as a targetRevision. As part of this branch, you will see that the `namespaces` key within the `argo-cd/ops/_base/patch/cluster-default.yml` has been removed. To validate the deconstruction, just run `kubectl get pods --all-namespaces -w`

> Only argo instances appeared to be destroyed; however an extensive validation was not conducted during the occurance of the issue.
