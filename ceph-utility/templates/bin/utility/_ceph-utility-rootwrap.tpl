#!/usr/bin/python
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
# PBR Generated from u'console_scripts'
import sys
import os
import syslog
from oslo_rootwrap.cmd import main

if "AUSER" in os.environ:
    if __name__ == "__main__":
        sys.exit(main())
elif "AUSER" not in os.environ and 'c1' == '{{ .Values.conf.utility.location_corridor }}':
    os.environ["AUSER"] = "devlab"
    if __name__ == "__main__":
        sys.exit(main())
else:
    syslog.syslog('Environment variable is not set, Please follow wiki and login')
    print("Environment variable is not Present, Please follow wiki and login")
    exit()
