#!/bin/sh
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

PID_1_STDOUT="/proc/1/fd/1"

# save stderr
exec 5<&2
# redirect stderr
exec 2>${PID_1_STDOUT}

set -ex

CALI_CTL="calicoctl"
LOG_KEY="-l"
LOG_LEVEL={{ .Values.conf.calicoctl_rootwrap.DEFAULT.syslog_log_level | quote }}

if [ "$1" == "$CALI_CTL" ] && [ "$2" != "$LOG_KEY" ]; then
    shift 1
    CMD="sudo /usr/local/bin/calicoctl-utility-rootwrap \
        /etc/calicoctl/rootwrap.conf \
        ${CALI_CTL} ${LOG_KEY} ${LOG_LEVEL} $*"
    ${CMD} | tee -a ${PID_1_STDOUT}
else
    CMD="sudo /usr/local/bin/calicoctl-utility-rootwrap \
        /etc/calicoctl/rootwrap.conf $*"
    # restore stderr as in this case user is looking for more verbosity
    exec 2<&5
    exec 5<&-
    ${CMD} 2>&1 | tee -a ${PID_1_STDOUT}
fi
