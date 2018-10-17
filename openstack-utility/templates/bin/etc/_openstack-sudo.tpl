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
DEFAULT:
# Configuration for openstack-rootwrap
# This file should be owned by (and only-writeable by) the root user
# List of directories to load filter definitions from (separated by ',').
# These directories MUST all be only writeable by root !
filters_path: /etc/openstack/rootwrap.d
# List of directories to search executables in, in case filters do not
# explicitely specify a full path (separated by ',')
# If not specified, defaults to system PATH environment variable.
# These directories MUST all be only writeable by root !
exec_dirs: /sbin,/usr/sbin,/bin,/usr/bin,/usr/local/bin,/usr/local/sbin
# Enable logging to syslog
# Default value is False
use_syslog: True
# Which syslog facility to use.
# Valid values include auth, authpriv, syslog, local0, local1...
# Default value is 'syslog'
syslog_log_facility: syslog
# Which messages to log.
# INFO means log all usage
# ERROR means only log unsuccessful attempts
syslog_log_level: INFO
