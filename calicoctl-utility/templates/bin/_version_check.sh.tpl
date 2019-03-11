#!/bin/sh

CLIENT_VER=$(nccli calicoctl version | awk '/Client Version/ {print $NF}')
CLUSTER_VER=$(nccli calicoctl version | awk '/Cluster Version/ {print $NF}')

if [ "${CLIENT_VER}" = "${CLUSTER_VER}" ]; then
    exit 0
else
    echo "Calico client and cluster version mismatch"
    exit 1
fi