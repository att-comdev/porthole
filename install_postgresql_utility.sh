#!/bin/bash
set -xe

#NOTE: Lint and package chart
: ${OSH_INFRA_PATH:="../openstack-helm-infra"}

make postgresql-utility

helm  upgrade --install postgresql postgresql-utility --namespace=utility

#NOTE: Wait for deploy
../${OSH_INFRA_PATH}/tools/deployment/common/wait-for-pods.sh utility

#NOTE: Validate Deployment info
kubectl get -n utility jobs --show-all
kubectl get -n utility secrets
kubectl get -n utility configmaps
kubectl