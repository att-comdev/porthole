#!/bin/bash
set -xe

#NOTE: Lint and package chart
: ${OSH_INFRA_PATH:="../../openstack-helm-infra"}

make mysqlclient-utility

#helm  install mysqlclient-utility --namespace=utility
helm  upgrade --install mysqlclient-utility mysqlclient-utility --namespace=utility

#NOTE: Wait for deploy
${OSH_INFRA_PATH}/tools/deployment/common/wait-for-pods.sh utility

#NOTE: Validate Deployment info
#kubectl get -n utility jobs --show-all
kubectl get -n utility jobs
kubectl get -n utility secrets
kubectl get -n utility configmaps

