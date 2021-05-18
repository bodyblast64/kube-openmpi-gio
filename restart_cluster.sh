
KUBE_NAMESPACE=default

helm template mpitest chart --namespace $KUBE_NAMESPACE -f values.yaml -f ssh-key.yaml | kubectl -n $KUBE_NAMESPACE delete -f -

while true
do
    echo "Checking for pods..."
    p=$(kubectl get pods | grep mpitest)
    if [[ -z "$p" ]]
    then
        break
    fi
    sleep 1
done
 

helm template mpitest chart --namespace $KUBE_NAMESPACE -f values.yaml -f ssh-key.yaml | kubectl -n $KUBE_NAMESPACE create -f -
