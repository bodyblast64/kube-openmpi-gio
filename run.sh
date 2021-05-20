MPI_CLUSTER_NAME=mpitest
KUBE_NAMESPACE=default

if [[ $1 == 'basic' ]];
then
kubectl -n $KUBE_NAMESPACE exec -it $MPI_CLUSTER_NAME-master -- mpiexec --allow-run-as-root \
  --hostfile /kube-openmpi/generated/hostfile \
  --use-hwthread-cpus \
  --display-map -n 140  sh -c 'echo $(hostname):hello'

  exit 0
fi

if [[ $1 == 'mpi4py' ]];
then
kubectl -n $KUBE_NAMESPACE exec -it $MPI_CLUSTER_NAME-master -- mpirun --allow-run-as-root \
  --hostfile /kube-openmpi/generated/hostfile \
  #--display-map -n 30 -npernode 5 \
  --use-hwthread-cpus \
  --display-map -n 140\
    python3 /app/mpi4py/demo/helloworld.py
  exit 0
fi

if [[ $1 == 'pywr-simple' ]];
then
kubectl -n $KUBE_NAMESPACE exec -it $MPI_CLUSTER_NAME-master -- mpirun --allow-run-as-root \
  --hostfile /kube-openmpi/generated/hostfile \
  --use-hwthread-cpus \
  --display-map -n 140\
   python3 /app/pywr-to-borg/examples/simple_reservoir_system.py mpi-search archive.json --max-evaluations=1000
  exit 0
fi

if [[ $1 == 'wre-test' ]];
then
kubectl -n $KUBE_NAMESPACE exec $MPI_CLUSTER_NAME-master -- mpirun --allow-run-as-root \
  --hostfile /kube-openmpi/generated/hostfile \
  --use-hwthread-cpus \
  --display-map -n 80\
  wre-moea borg-search /moea/wre/models/ruthamford-historic.json --max-evaluations 1500 --output-frequency 50 --random-seed 4 --suffix=test
  exit 0
fi

if [[ $1 == 'wre-full' ]];
then
kubectl -n $KUBE_NAMESPACE exec -it $MPI_CLUSTER_NAME-master -- mpirun --allow-run-as-root \
  --hostfile /kube-openmpi/generated/hostfile \
  --use-hwthread-cpus \
  --display-map -n 140\
  export HDF5_USE_FILE_LOCKING=FALSE; wre-moea borg-search models/wre-search-stochastic-lpm.json --max-evaluations 150000 --output-frequency 500 --random-seed 4 --suffix=test > $(HOME)/logs/moea.log &
  exit 0
fi


usage(){
    echo "./run.sh basic or ./run.sh mpi4py or ./run.py pywr-simple or ./run.py wre-test or ./run.py wre-full"
}

usage
