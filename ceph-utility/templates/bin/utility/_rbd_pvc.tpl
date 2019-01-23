#!/bin/bash

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

usage() {
  echo "Backup Usage: $0 [-b <pvc name>] [-n <namespace>] [-d <backup dest> (optional, default: /backup)] [-p <ceph rbd pool> (optional, default: rbd)]"
  echo "Restore Usage: $0 [-r <restore_file>] [-p <ceph rbd pool> (optional, default: rbd)]"
  exit 1
}

while getopts ":b:p:n:d:r:h:" opt; do
  case $opt
  in
    b) pvc_name=${OPTARG};;
    n) nspace=${OPTARG};;
    d) backup_dest=${OPTARG};;
    r) restore_file=${OPTARG};;
    p) rbd_pool=${OPTARG};;
    h) usage ;;
  esac
done

if [[ -z "${pvc_name}" || -z "${nspace}" ]]; then
  if [[ -z "${restore_file}" ]]; then
    usage
    echo "ERROR: Missing command line arguement(s)"
    exit 1
  fi
fi

if [[ -z "${rbd_pool}" ]]; then
  rbd_pool="rbd"
fi

timestamp="$(date +%F_%T)"

if [[ ! -z "${restore_file}" ]]; then
  if [[ -e "${restore_file}" ]]; then
    rbd_image="$(echo "${restore_file}" |  cut -f 1 -d '.')"
    if (nccli rbd info "${rbd_pool}"/"${rbd_image}" | grep -q id); then
      nccli rbd mv ${rbd_pool}/${rbd_image} ${rbd_pool}/${rbd_image}-${timestamp}
      echo "WARNING: Existing PVC/RBD image has been moved to ${rbd_pool}/${rbd_image}-${timestamp} !" 
    fi
    nccli rbd import ${restore_file} ${rbd_pool}/${rbd_image}
    echo "PVC restored into ${rbd_pool}/${rbd_image} !"
  else
    echo "ERROR: Missing restore file."
    exit 1
  fi
else
  if [[ -z "${backup_dest}" ]]; then
    backup_dest="/backup"
  fi
  if [[ ! -d "${backup_dest}" ]]; then
    echo "ERROR: Backup destination does not exist, cannot continue with the backup!"
    exit 1
  fi

  echo "Backing up ${pvc_name} with namespace ${nspace}."
  volume="$(kubectl -n ${nspace} get pvc ${pvc_name} --no-headers | awk '{ print $3 }')"
  rbd_image="$(kubectl get pv "${volume}" -o json | jq -r '.spec.rbd.image')"

  if [[ -z "${volume}" ]] || (! nccli rbd info "${rbd_pool}"/"${rbd_image}" | grep -q id); then
    echo "ERROR: PVC does not exist or is missing. Cannot continue with backup for ${pvc_name}!"
    exit 1
  else
    # Create current snapshot and export to a file
    snap_name="${pvc_name}-${timestamp}"
    backup_name="${rbd_image}.backup-${timestamp}"
    nccli rbd snap create ${rbd_pool}/${rbd_image}@${snap_name}
    nccli rbd export ${rbd_pool}/${rbd_image}@${snap_name} ${backup_dest}/${backup_name}
    # Remove snapshot otherwise we may see an issue cleaning up the PVC from K8s, and from Ceph.
    nccli rbd snap rm ${rbd_pool}/${rbd_image}@${snap_name}
    echo "PVC saved to ${backup_dest}/${backup_name} !"
  fi
fi

exit 0
