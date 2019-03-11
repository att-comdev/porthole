#!/bin/sh
{{/*
Copyright 2019 The Openstack-Helm Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

set -euxo pipefail

CLIENT_VER=$(sudo calicoctl version | awk '/Client Version/ {print $NF}')
CLUSTER_VER=$(sudo calicoctl version | awk '/Cluster Version/ {print $NF}')

if [ "${CLIENT_VER}" = "${CLUSTER_VER}" ]; then
    exit 0
else
    echo "Calico client and cluster version mismatch"
    exit 1
fi
