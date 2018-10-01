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
sudo sed -i 's/$PrivDropToUser syslog/$PrivDropToUser nobody/' /etc/rsyslog.conf
sudo sed -i 's/$PrivDropToGroup syslog/$PrivDropToGroup nobody/' /etc/rsyslog.conf
sudo ./tmp/managekey.sh
sudo /etc/init.d/rsyslog start
sudo touch /var/log/stdout
tail -f /var/log/stdout
