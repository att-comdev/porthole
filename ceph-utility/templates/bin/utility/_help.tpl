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
echo "Usage:"
echo "Following commands must be run in same format and argument as shown below"
echo " nccli rados df"
echo " nccli rados lspools"
echo " nccli rados --pool <poolname> ls"
echo " nccli rados --pool <poolname> lssnap"
echo " nccli rados --help"
echo " nccli rados --pool <poolname> get <object>"
echo " nccli rados --pool <poolname> listattr FO"
echo " nccli rados --pool <poolname> getxattr obj attr"
echo " nccli rados --pool <poolname> stat <object>"
echo " nccli rados --pool <poolname> stat2 <object>"
echo " nccli rados --pool <poolname> listomapkeys <object>"
echo " nccli rados --pool <poolname> listomapvals <object>"
echo " nccli rados --pool <poolname> getomapval testfile key"
echo " nccli rados --pool <poolname> listwatchers boot.rbd"
echo " nccli rados --pool <poolname> getomapheader name"
echo " nccli rados list-inconsistent-pg <poolname> --format=json-pretty"
echo " nccli rados list-inconsistent-obj <placement-group-id>"
echo " nccli rados list-inconsistent-snapset <placement-group-id> --format=json-pretty"
echo " nccli rados -p data clonedata foo.tmp foo --object-locator foo"
echo " nccli rados --pool <poolname> bench 10 write -b 4000 -t 8 --run-name test"
echo " nccli rados --pool <poolname> cleanup"


  exit 1
}

usage

#if [ $# -eq 0 ]; then
#  usage
#else
#  echo "usage"
#fi

