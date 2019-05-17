#!/bin/bash
set -xe

make etcdctl-utility

helm  upgrade --install etcdctl-utility etcdctl-utility --namespace=utility

#NOTE: Validate Deployment info
kubectl get -n utility secrets
kubectl get -n utility configmaps
