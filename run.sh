MPI_CLUSTER_NAME=mpitest
KUBE_NAMESPACE=default

if [[ $1 == 'basic' ]];
then
kubectl -n $KUBE_NAMESPACE exec -it $MPI_CLUSTER_NAME-master -- mpiexec --allow-run-as-root \
  --hostfile /kube-openmpi/generated/hostfile \
  --display-map -n 3 -npernode 1 \
  sh -c 'echo $(hostname):hello'
  exit 0
fi

if [[ $1 == 'mpi4py' ]];
then
kubectl -n $KUBE_NAMESPACE exec -it $MPI_CLUSTER_NAME-master -- mpiexec --allow-run-as-root \
  --hostfile /kube-openmpi/generated/hostfile \
  --display-map -n 30 -npernode 5 \
  python3 /app/mpi4py/demo/helloworld.py
  exit 0
fi


usage(){
    echo "./run.sh basic or ./run.sh mpi4py"
}

usage
