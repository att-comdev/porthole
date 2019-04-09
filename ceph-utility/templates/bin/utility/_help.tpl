#!/bin/bash
{{/*
Copyright 2017 The Openstack-Helm Authors.

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

set -ex

usage() {
  set +ex
  echo "Usage:"
  echo " nccli rados lspools"
  echo " nccli rados df"
  echo " nccli rados --pool <poolname> ls"
  echo " nccli rados --pool <poolname> lssnap"
  echo " nccli rados --pool <poolname> mksnap <>"
  echo " nccli rados --pool <poolname> get"

  exit 1
}

usage

#if [ $# -eq 0 ]; then
#  usage
#else
#  echo "usage"
#fi

