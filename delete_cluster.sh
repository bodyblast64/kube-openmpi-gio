export KUBE_NAMESPACE=default
helm template mpitest chart --namespace $KUBE_NAMESPACE -f values.yaml -f ssh-key.yaml | kubectl -n $KUBE_NAMESPACE delete -f -
