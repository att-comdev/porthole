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
input="/opt/client-keyring"
while IFS= read -r var
do
  echo -e "[client.admin]\nkey = $var"| tee /etc/ceph/ceph.client.admin.keyring > /dev/null
done < "$input"
chmod 600 /etc/ceph/ceph.client.admin.keyring
sed -i 's/$PrivDropToUser syslog/$PrivDropToUser nobody/' /etc/rsyslog.conf
/etc/init.d/rsyslog restart
sed -i 's#"(%s > %s) Executing#\x27ActualUser=\x27 + os.environ[\x27AUSER\x27] + "(%s > %s) Executing#g' /usr/lib/python2.7/dist-packages/oslo_rootwrap/wrapper.py
sed -i 's/import logging/import logging\nimport os/g' /usr/lib/python2.7/dist-packages/oslo_rootwrap/cmd.py
sed -i 's#("Unauthorized command: %s#(\x27ActualUser=\x27 + os.environ[\x27AUSER\x27] + ": Unauthorized command: %s#g' /usr/lib/python2.7/dist-packages/oslo_rootwrap/cmd.py
