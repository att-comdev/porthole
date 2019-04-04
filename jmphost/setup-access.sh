#!/bin/bash

if [[ ${#} -lt 2 ]] ; then
  echo "Abort - Usage $0 <SITE NAME> <USER_ID> <NAMESPACE>"
  exit 1
fi

SITE_NAME=$1 ; LOGNAME=$2 ; NAMESPACE=$3

LOGNAME_GRP=$(grep ${LOGNAME} /etc/passwd |cut -d":" -f3)

# set default env variables
: ${USER_HOME:=$HOME}
: ${USER_KUBECFG:=$USER_HOME/.kube/config}

function _addSourceList() {
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
     tee -a /etc/apt/sources.list.d/kubernetes.list
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  apt-get update
}

# Install dependencies once
function _installDep () {

   # kubectl
   if [[ $1 == 'kubectl' ]] ; then
      echo "Installing [${1}] dependency required..."
      apt-get install -y kubectl
   fi

   # Go Language
   if [[ $1 == 'golang' ]] ; then
      echo "Installing [${1}] dependency required..."
      go_pkg="go1.12.4.linux-amd64.tar.gz"
      wget -t 3 -T 15 https://dl.google.com/go/${go_pkg}
      if [[ $? -eq '0' ]] ; then
         sleep 5
         echo "Extracting ${go_pkg} ..."
         tar -xzf ${go_pkg} -C /usr/local/
         if [[ $? -eq '0' ]] ; then
            echo "Extracting ${go_pkg} successfully..."
            # remove to reclaim disk space
            rm -f ${go_pkg}
         fi
      fi
   fi

   # ClientGo
   if [[ $1 == 'ClientGo' ]] ; then
      echo "Installing [${1}] dependency required..."
      export GOPATH=$HOME/gocode
      export GOROOT=/usr/local/go
      export GO111MODULE=on
      export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
      go get k8s.io/client-go@v11.0.0
      chown -R ${LOGNAME}:${LOGNAMEG_GRP} $GOPATH
   fi

}

# Create kubeconfig skelton file
function _createConfig() {
tee ${USER_KUBECFG} <<EOF
---
apiVersion: v1

kind: Config

namespace: ${NAMESPACE}

clusters:
  # Authentication via API Ingress end point for a given site
  - cluster:
    name: ${SITE_NAME}
    server: https://kubernetes-nc.${SITE_NAME}.cci.att.com:443
    #certificate-authority: "/etc/kubernetes/ca.pem"

contexts:
  - name: ${SITE_NAME}
    context:
      cluster: ${SITE_NAME}
      user: ${LOGNAME}

current-context: ${SITE_NAME}

preferences: {}

users:
  - name: ${LOGNAME}
    user:
      exec:
      # Run time env variables used to authenthicate
        env:
        - name: "OS_USER_DOMAIN_NAME"
          value: nc
        - name: "OS_REGION_NAME"
          value: ${SITE_NAME}
        - name: "OS_USERNAME"
          value: ${LOGNAME}
        - name: "OS_PASSWORD"
          value: "<USER-PASSWORD>"
        - name: "OS_PROJECT_NAME"
          value: default
        - name: "OS_DEFAULT_NAME"
          value: default
        - name: "OS_AUTH_URL"
          value: "https://https//identify-nc.${SITE_NAME}.cci.att.com:443"
        - name: "OS_IDENTITY_API_VERSION"
          value: "3"

      command: "../gocode/pkg/mod/k8s.io/client-go@v11.0.0+incompatible"

      apiVersion: "client.authentication.k8s.io/v1beta1"

EOF
}

# checking and installing 'kubectl'
if [[ ! -x /usr/local/bin/kubectl ]] ; then
   echo "[Kubectl] is not found on this system.."
   echo "Checking user[${LOGNAME}] sudo ability"
   let num=$(id -u)
   if [ $num -ne '0' ]; then
      echo "Abort dependencies installation. You [$LOGNAME] are not root yet"
      exit 1
   else
      echo "Looking good. You [$LOGNAME] are root now"
      _addSourceList
      _installDep "kubectl"
   fi
fi

# checking and install 'GoLang'
if [[ ! -x /usr/local/go/bin/go ]] ; then
   echo "[Golang] is not found on this system.."
   echo "Checking user[${LOGNAME}] sudo ability"
   let num=$(id -u)
   if [ $num -ne '0' ]; then
      echo "Abort dependencies installation. You [$LOGNAME] are not root yet"
      exit 1
   else
      echo "Looking good. You [$LOGNAME] are root now"
      _installDep "golang"
   fi
fi

# checking and install 'ClientGo'
# Source of ref: https://github.com/kubernetes/client-go
if [[ ! -d ${HOME}/gocode/pkg ]] ; then
   echo "[ClientGo] is not found on this system."
   _installDep "ClientGo"
fi


if [[ ! -d ${USER_HOME}/.kube ]]; then
   mkdir ${USER_HOME}/.kube
   chown -R ${LOGNAME}:${LOGNAME_GRP} ${USER_HOME}/.kube
fi

# create config if it does not exit
if [[ ! -f ${USER_KUBECFG} ]]; then
   _createConfig
   chown ${LOGNAME}:${LOGNAME_GRP} ${USER_HOME}/.kube/config
fi

# staging uc functions to a common area
if [[ ! -d /usr/local/uc/bin/ ]]; then
   mkdir -p /usr/local/uc/bin/
   cp -p funs_uc.sh /usr/local/uc/bin/
   chmod 755 -R /usr/local/uc
fi


# Update user bash rc script to include uc funcions

if [[ -f ${HOME}/.bashrc ]]; then
cp -p ${HOME}/.bashrc ${HOME}/.bashrc.jmp.bck

tee -a ${HOME}/.bashrc <<EOF

# Utility container common functions
if [[ -f /usr/local/uc/bin/funs_uc.sh ]]; then
  . /usr/local/uc/bin/funs_uc.sh
fi

EOF

fi