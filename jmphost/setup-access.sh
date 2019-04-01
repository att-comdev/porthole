#!/bin/bash
set -xe

proxy="http://one.proxy.att.com:8888"
export http_proxy=${proxy}
export https_proxy=${proxy}

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
apt-get update
apt-get install -y kubectl


: ${USER_HOME:=$HOME}
: ${USER_KUBECFG:=$USER_HOME/.kube/conf}


if [ ! -d ${USER_HOME}/.kube ]; then
   mkdir ${USER_HOME}/.kube
fi

if [ ! -f ${USER_KUBECFG} ]; then
  tee ${USER_KUBECFG} <<EOF
--
apiVersion: v1
clusters:
 -cluster:
   server: https://127.0.0.1:6553
   certificate-authority: pki/cluster-ca.pm
   name: kubernetes
contexts:
 -context:
   cluster: kubernetes
    user: ${LOGNAME}
    name: ${LOGNAME}@kubernetes
    current-context: ${LOGNAME}@kubernetes
    kind: Config
    preferences: {}
users:
 -name: ${LOGNAME}
   user:
   client-certificate: pki/${LOGNAME}.pem
   client-key: pki/${LOGNAME}-key.pem
EOF

fi