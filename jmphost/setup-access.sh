#!/bin/bash
set -xe

if [ ${#} -lt 1 ] ; then
  echo "Abort - Use $0 [https:[portnum] url of the cluster server]"
  exit 1
fi

proxy="http://one.proxy.att.com:8888"
export http_proxy=${proxy}
export https_proxy=${proxy}

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
apt-get update
apt-get install -y kubectl


: ${USER_HOME:=$HOME}
: ${USER_KUBECFG:=$USER_HOME/.kube/conf}
URL=$1

if [ ! -d ${USER_HOME}/.kube ]; then
   mkdir ${USER_HOME}/.kube
fi

if [ ! -f ${USER_KUBECFG} ]; then
  tee ${USER_KUBECFG} <<EOF
--
apiVersion: v1
clusters:
 -cluster:
   server: $URL
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
unset http_proxy https_proxy