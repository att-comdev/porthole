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
COMMAND="${@:-usage}"

function check_osd_status () {
  OSD_ID=$(nccli ceph osd tree -f json-pretty | jq '.nodes[]|select(.type=="osd")|select(.status == "down")|.id')
  if [ "${OSD_ID}" != '' ];then
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
   nccli ceph osd purge $id --yes-i-really-mean-it
   sleep 3
  done
}

function reweight_osds () {
  for OSD_ID in $(nccli ceph --cluster "${CLUSTER}" osd df | awk '$3 == "0" {print $1}'); do
    OSD_WEIGHT=$(nccli ceph --cluster "${CLUSTER}" osd df --format json-pretty| grep -A7 "\bosd.${OSD_ID}\b" | awk '/"kb"/{ gsub(",",""); d= $2/1073741824 ; r = sprintf("%.2f", d); print r }');
    nccli ceph --cluster "${CLUSTER}" osd crush reweight osd.${OSD_ID} ${OSD_WEIGHT};
  done
}

usage() {
  set +ex
  echo "Usage:  ./osd-maintenance.sh osd_remove"
  echo "        ./osd-maintenance.sh osd_add"
  echo "        ./osd-maintenance.sh check_osd_status"
  echo "        ./osd-maintenance.sh reweight_osds"
  exit 1
}

if [ $# -eq 0 ]; then
  $COMMAND
else
  case $1 in
  osd_remove ) osd_remove
  ;;
  check_osd_status ) check_osd_status
  ;;
  reweight_osds ) reweight_osds
  ;;
  *)
  usage
  exit 1
  ;;
  esac
fi
