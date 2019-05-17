ARG FROM=docker.io/ubuntu:xenial
FROM ${FROM}
MAINTAINER Jagan Mohan Kavva <jk330k@att.com>

LABEL org.opencontainers.image.authors='att-comdev and Openstack-Helm Authors'
LABEL org.opencontainers.image.url='https://github.com/att-comdev/porthole'
LABEL org.opencontainers.image.documentation='https://github.com/att-comdev/porthole/blob/master/README'
LABEL org.opencontainers.image.source='https://github.com/att-comdev/porthole'
LABEL org.opencontainers.image.vendor='att-comdev and Openstack-Helm Authors'
LABEL org.opencontainers.image.licenses='BSD-3-Clause'

ARG ETCDCTL_VERSION=3.2.18
ARG KUBE_VERSION=1.12.2

RUN set -xe \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get dist-upgrade -y \
    && apt-get install -y bash python-oslo.rootwrap moreutils curl rsyslog python3-oslo.rootwrap python-pip \
    && pip install zuul \
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
