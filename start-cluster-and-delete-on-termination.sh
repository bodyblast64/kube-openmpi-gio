#!/bin/bash

# This script starts the cluster and after it terminates the full cluster when the master is in "completed" state
. ./moea-variables.sh

checking_pods_are_running() {
	echo "Checking for pods..."
	p=$(kubectl get pods | grep $TEMPLATE_NAME)
	echo $p
	if [[ -z "$p" ]]
	then
	    return 0
	fi
	return 1
}

checking_main_pod_is_completed() {
	#echo "Checking for completed main pod..."
	p=$(kubectl get pods | grep ${TEMPLATE_NAME}-master | awk '{print $3}')

	if [[ -z "$p" ]]
	then
	  return 1
	elif [ "$p" == "Completed" ]
	then
		return 1
	fi
	return 0
}
# checking_pods_are_running
# echo $?
# if [ $? -eq 1 ]
# then
# 	echo "IS RUNNING"
# else
# 	echo "IS NOT RUNNING"
# fi
#
# checking_main_pod_is_completed
# if [[ $? -eq 1  ]]
# then
# 	echo "IS COMPLETED"
# else
# 	echo "IS NOT COMPLETED"
# fi
# echo ${TEMPLATE_NAME}-master
# exit 1

while :
do
	echo "Checking completion previous job"
	checking_pods_are_running
	if [[ $? -eq 0 ]]
	then
		# No Pods running
		echo "No pods running"
		./start_cluster.sh
		break
	fi

	checking_main_pod_is_completed
	if [[ $? -eq 1 ]]
	then
		# The main running pod is  completed
		echo "Main pod is completed"
		./restart_cluster.sh
		break
	fi
	# Wait next tick
	sleep 5
done

while :
do
	echo "Checking completion Main Job"
	checking_main_pod_is_completed
	if [[ $? -eq 1 ]]
	then
		# The main running pod is  completed
		echo "Main pod is completed"
		./delete_cluster.sh
		break
	fi
	# Wait next tick
	sleep 5
done
