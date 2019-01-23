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

set -ex

usage() {
  echo "Backup Usage: $0 [-p <pvc name>] [-n <namespace>] [-d <backup dest> (optional) ]"
  echo "Restore Usage: $0 [-r <restore_file>]"
  exit 1
}

while getopts ":p:n:d:r:h:" opt; do
  case $opt
  in
    p) pvc_name=${OPTARG};;
    n) nspace=${OPTARG};;
    d) backup_dest=${OPTARG};;
    r) restore_file=${OPTARG};;
    h) usage ;;
  esac
done

if [[ -z "${pvc_name}" || -z "${nspace}" ]]; then
  if [[ -z "${restore_file}" ]]; then
    usage
    echo "ERROR: Missing command line arguement(s)."
    exit 1
  fi
fi

if [[ ! -z "${restore_file}" ]]; then
  if [[ -e "${restore_file}" ]]; then
    unxz ${restore_file} -c | rbd import $(echo "${restore_file}" |  cut -f 1 -d '.') \
      rbd/$(echo "${restore_file}" |  cut -f 1 -d '.')
  else
    echo "ERROR: Missing restore file."
    exit 1
  fi
else
  if [[ -z "${backup_dest}" ]]; then
    backup_dest="/backup"
  fi

  echo "Backing up ${pvc_name} with namespace ${nspace}."
  volume="$(kubectl -n ${nspace} get pvc ${pvc_name} --no-headers | awk '{ print $3 }')"

  if [ -z "${volume}" ]; then
    echo "ERROR: PVC does not exist or is missing. Cannot continue with backup for ${pvc_name}"
    exit 1
  else
    rbd_image="$(kubectl get pv "${volume}" -o json | jq -r '.spec.rbd.image')"
    # Create current snapshot and export to a file
    snap_name="${pvc_name}-$(date +%F_%T)"
    rbd snap create rbd/${rbd_image}@${snap_name}
    rbd export rbd/${rbd_image}@${snap_name} - | xz  -0v --threads=0 | tee ${backup_dest}/${rbd_image}.img.xz
    # Remove snapshot otherwise we may see an issue cleaning up the PVC from K8s
    rbd snap rm rbd/${rbd_image}@${snap_name}
  fi
fi
