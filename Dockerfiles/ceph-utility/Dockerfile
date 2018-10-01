FROM ubuntu:16.04

RUN set -xe \
	\
	&& echo '#!/bin/sh' > /usr/sbin/policy-rc.d \
	&& echo 'exit 101' >> /usr/sbin/policy-rc.d \
	&& chmod +x /usr/sbin/policy-rc.d \
	&& sed -i '/nobody/d' /etc/passwd \
	&& echo "nobody:x:65534:65534:nobody:/nonexistent:/bin/bash" >> /etc/passwd \
	\
	&& dpkg-divert --local --rename --add /sbin/initctl \
	&& cp -a /usr/sbin/policy-rc.d /sbin/initctl \
	&& sed -i 's/^exit.*/exit 0/' /sbin/initctl \
	\
	&& echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup \
	\
	&& echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean \
	&& echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean \
	&& echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean \
	\
	&& echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages \
	\
	&& echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes \
	\
	&& echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests \
        && apt-get update && apt-get install -y wget apt-transport-https \
        && wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add - \
        && echo deb https://download.ceph.com/debian-luminous/ xenial main | tee /etc/apt/sources.list.d/ceph.list \
        && apt-get update && apt-get install -y bash python-oslo.rootwrap moreutils vim sudo screen ceph-common python-rbd radosgw rsyslog x11-apps \
        && apt-get remove --purge -y wget apt-transport-https && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
