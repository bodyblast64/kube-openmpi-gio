
KUBE_NAMESPACE=default

helm template moea-mpi chart --namespace $KUBE_NAMESPACE -f values.yaml -f ssh-key.yaml | kubectl -n $KUBE_NAMESPACE delete -f -

while true
do
    echo "Checking for pods..."
    p=$(kubectl get pods | grep moea-mpi)
    if [[ -z "$p" ]]
    then
        break
    fi
    sleep 1
done
 
cp values.yaml values_edited.yaml
sed -i "s/<USER>/$USER/g" values_edited.yaml
helm template moea-mpi chart --namespace $KUBE_NAMESPACE -f values_edited.yaml -f ssh-key.yaml | kubectl -n $KUBE_NAMESPACE create -f -
