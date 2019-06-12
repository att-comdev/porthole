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

function check_osd_status () {
  OSD_ID=$(ceph osd tree -f json-pretty | jq '.nodes[]|select(.type == "osd")|select(.status == "down")|.id')
  if [ "${OSD_ID}" != '' ];then
      for i in $OSD_ID; do
      echo "OSD id $i is in Down Status"
      done
  else
      echo "All OSDs are Good"
      exit
  fi
}

function osd_remove () {
  check_osd_status
  for id in $OSD_ID; do
   read -p "Enter 'yes' to purge OSD=$id and 'no' to skip=" YN
   if [[ $YN == "y" || $YN == "yes" ]]; then
       echo "Purging OSD=$id"
       ceph osd purge $id --yes-i-really-mean-it
       sleep 3
   elif [[ $YN == "n" || $YN == "no" ]]; then
       echo "Not purging OSD=$id"
   else
       echo "Invalid Option"
   fi
  done
}

# Checks if the given OSD is in downstate and then removes OSD by ID
function remove_osd_in_down_state_by_id () {
      OSDID=$1
      OSD_STATUS=$(ceph osd tree -f json-pretty | jq '.nodes[]|select(.type == "osd")|select(.id == '$OSDID')|.status')
      if [ "$OSD_STATUS" == '"down"' ]; then
          echo "OSD id $OSDID is in Down Status, So purging it"
          ceph osd purge $OSDID --yes-i-really-mean-it
      elif [[ -z "$OSD_STATUS" ]]; then
          echo "OSD id $OSDID is not found, Please enter correct OSD id"
          exit
      else
          echo "OSD id $OSDID is not in Down Status, Not purging it"
          exit
      fi
}

# Checks if any OSD has weight '0' and then assgins weight, So Ceph can write data to it
function reweight_osds () {
  for OSD_ID in $(ceph osd df | awk '$3 == "0" {print $1}'); do
    OSD_WEIGHT=$(ceph osd df --format json-pretty| grep -A7 "\bosd.${OSD_ID}\b" | awk '/"kb"/{ gsub(",",""); d= $2/1073741824 ; r = sprintf("%.2f", d); print r }');
    ceph osd crush reweight osd.${OSD_ID} ${OSD_WEIGHT};
  done
}

usage() {
  set +ex
  echo "Usage:  nccli osd-maintenance check_osd_status"
  echo "        nccli osd-maintenance osd_remove"
  echo "        nccli osd-maintenance osd_remove_by_id --osd-id <OSDID>"
  echo "        nccli osd-maintenance reweight_osds"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
else
  OSDID=""
  case $1 in
    osd_remove_by_id )
        shift
        if [ "$1" == "--osd-id" ]; then
           shift
           if [ "$1" == "" ]; then
              usage
              exit 1
           fi
           OSDID=$1
           remove_osd_in_down_state_by_id $OSDID
        else
           usage
           exit 1
        fi
    ;;
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
