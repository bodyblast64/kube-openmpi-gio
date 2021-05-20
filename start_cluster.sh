KUBE_NAMESPACE=default
cp values.yaml values_edited.yaml
sed -i "s/<USER>/$USER/g" values_edited.yaml
helm template moea-mpi chart --namespace $KUBE_NAMESPACE -f values_edited.yaml -f ssh-key.yaml | kubectl -n $KUBE_NAMESPACE create -f -
