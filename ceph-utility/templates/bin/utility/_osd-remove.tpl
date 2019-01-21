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
COMMAND="${@:-check_and_remove_osd}"

function check_osd_status () {
OSD_ID=$(nccli ceph osd tree -f json-pretty | jq '.nodes[]|select(.type=="osd")|select(.status == "down")|.id')
if [ "${var-}" != '' ];then
    for i in $OSD_ID; do
     echo "This osd id is $i in Down Status"
    done
else
    echo "All OSDs are Good"
    exit
fi
}

function osd_remove () {
  check_osd_status
  for id in $OSD_ID; do
   ceph osd purge $id --yes-i-really-mean-it
   sleep 3
  done

}

function reweight_osds () {
  
  for OSD_ID in $(ceph --cluster "${CLUSTER}" osd df | awk '$3 == "0" {print $1}'); do
    OSD_WEIGHT=$(ceph --cluster "${CLUSTER}" osd df --format json-pretty| grep -A7 "\bosd.${OSD_ID}\b" | awk '/"kb"/{ gsub(",",""); d= $2/1073741824 ; r = sprintf("%.2f", d); print r }');
    ceph --cluster "${CLUSTER}" osd crush reweight osd.${OSD_ID} ${OSD_WEIGHT};
  done
}

function check_and_remove_osd () {
  osd_remove
}
$COMMAND
