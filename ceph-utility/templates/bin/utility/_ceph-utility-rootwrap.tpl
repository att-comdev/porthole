#!/usr/bin/python
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
import sys
import os
import logging
import getpass
from oslo_rootwrap.cmd import main


exec_name = sys.argv[0]
host_name = os.environ.get("HOSTNAME")
log_level = {{ .Values.conf.cephrootwrap.DEFAULT.syslog_log_level | quote }}
facility = {{ .Values.conf.cephrootwrap.DEFAULT.syslog_log_facility | quote }}

if "AUSER" in os.environ:
    userName = os.environ["AUSER"]
elif "AUSER" not in os.environ and 'c1' == '{{ .Values.conf.utility.location_corridor }}':
    os.environ["AUSER"] = getpass.getuser()
    userName = os.environ["AUSER"]
else:
    print("User environment not configured properly, please follow the steps as mentioned on wiki to execute commands on a utility container")
    exit()

try:
    handler = logging.handlers.SysLogHandler(address='/dev/log',facility=facility)
except IOError:
    print("Unable to setup logging, for security reasons pod will not start")
    exit()

formatter = logging.Formatter('%(asctime)s ' + host_name + ' ' + '%(levelname)s' +
    os.path.basename(exec_name) + ': ' + 'ActualUser=' + userName + ': %(message)s')
handler.setFormatter(formatter)
root = logging.getLogger()
root.setLevel(log_level)
root.addHandler(handler)

if __name__ == "__main__":
    sys.exit(main())
