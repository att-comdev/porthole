ARG UBUNTU_RELEASE=xenial

FROM docker.io/sreejithpunnapuzha/ubuntu:${UBUNTU_RELEASE}
LABEL maintainer="sreejith.punnapuzha@outlook.com"

ARG UBUNTU_RELEASE=xenial

RUN set -xe \
    && export DEBIAN_FRONTEND=noninteractive \
	  && sed -i '/nobody/d' /etc/passwd \
	  && echo "nobody:x:65534:65534:nobody:/nonexistent:/bin/bash" >> /etc/passwd \
	  && apt update && apt dist-upgrade -y \
    && apt update && apt install -y bash moreutils vim sudo screen rsyslog x11-apps python-oslo.rootwrap python-openstackclient python-glanceclient python-novaclient python-neutronclient python-cinderclient python-heat python3-oslo.rootwrap python3-openstackclient python3-glanceclient python3-novaclient python3-neutronclient python3-cinderclient \
    && apt clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
