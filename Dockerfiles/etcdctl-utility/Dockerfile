ARG FROM=docker.io/ubuntu:xenial
FROM ${FROM}

ARG ETCDCTL_VERSION=3.2.18
ARG KUBE_VERSION=1.12.2

RUN set -xe \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get dist-upgrade -y \
    && apt-get install -y bash python-oslo.rootwrap moreutils curl rsyslog \
    && TMP_DIR=$(mktemp --directory) \
    && cd ${TMP_DIR} \
    && curl -sSL https://github.com/coreos/etcd/releases/download/v${ETCDCTL_VERSION}/etcd-v${ETCDCTL_VERSION}-linux-amd64.tar.gz | tar xfz - \
    && mv ${TMP_DIR}/etcd-v${ETCDCTL_VERSION}-linux-amd64/etcdctl /usr/bin/etcdctl \
    && chmod +xr /usr/bin/etcdctl \
    && curl -sSL https://dl.k8s.io/v${KUBE_VERSION}/kubernetes-client-linux-amd64.tar.gz | tar -zxv --strip-components=1 \
    && mv ${TMP_DIR}/client/bin/kubectl /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* ${TMP_DIR}
CMD ["/bin/bash"]
