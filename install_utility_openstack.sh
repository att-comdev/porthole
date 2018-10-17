#!/bin/bash
set -xe

#NOTE: Lint and package chart
export OSH_INFRA_PATH=~/openstack-helm-infra
#export PORTHOLE_PATH=~/porthole
#cp -r  $OSH_INFRA_PATH/helm-toolkit $PORTHOLE_PATH/openstack-utility
make openstack-utility

helm  upgrade --install openstack-utility ./openstack-utility --namespace=utility
#NOTE: Wait for deploy
./$OSH_INFRA_PATH/tools/deployment/common/wait-for-pods.sh openstack-utility

#NOTE: Validate Deployment info
kubectl get -n utility jobs --show-all
kubectl get -n utility secrets
kubectl get -n utility configmaps
