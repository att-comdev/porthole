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
sed -i 's/$PrivDropToUser syslog/$PrivDropToUser nobody/' /etc/rsyslog.conf
/etc/init.d/rsyslog start

sed -i "/rootwrap_logger.setLevel/s/.*/#&/" /usr/lib/python2.7/dist-packages/oslo_rootwrap/wrapper.py
sed -i "/handler.setFormatter/s/.*/#&/" /usr/lib/python2.7/dist-packages/oslo_rootwrap/wrapper.py
sed -i "/os.path.basename/s/.*/#&/" /usr/lib/python2.7/dist-packages/oslo_rootwrap/wrapper.py
sed -i "/rootwrap_logger.addHandler/s/.*/#&/" /usr/lib/python2.7/dist-packages/oslo_rootwrap/wrapper.py

# for readiness probe
touch /tmp/done
