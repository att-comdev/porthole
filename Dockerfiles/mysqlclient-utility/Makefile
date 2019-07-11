# Copyright 2019 The Openstack-Helm Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SHELL := /bin/bash

DOCKER_REGISTRY            ?= quay.io
IMAGE_NAME                 ?= mysql-client-utility
IMAGE_PREFIX               ?= attcomdev
IMAGE_TAG                  ?= latest
PROXY                      ?= http://proxy.foo.com:8000
NO_PROXY                   ?= localhost,127.0.0.1,.svc.cluster.local
USE_PROXY                  ?= false
PUSH_IMAGE                 ?= false
# use this variable for image labels added in internal build process
LABEL                      ?= org.attcomdev.build=community
COMMIT                     ?= $(shell git rev-parse HEAD)
MYSQL_BASE_IMAGE       ?= ${DOCKER_REGISTRY}/mysql/client:${MYSQL_VERSION}
MYSQL_BUILD_CTX        ?= mysql-utility
export

IMAGE := ${DOCKER_REGISTRY}/${IMAGE_PREFIX}/${IMAGE_NAME}:${IMAGE_TAG}

# Build mysqlclient-utility Docker image for this project
.PHONY: images
images: build_$(IMAGE_NAME)

# Make targets intended for use by the primary targets above.
.PHONY: build_$(IMAGE_NAME)
build_$(IMAGE_NAME):
ifeq ($(USE_PROXY), true)
    docker build -t $(IMAGE) --network=host -f Dockerfile.alpine \
        --label $(LABEL) \
        --label MYSQL_VERSION=$(IMAGE_TAG) \
        --label "org.opencontainers.image.revision=$(COMMIT)" \
        --label "org.opencontainers.image.created=$(shell date --rfc-3339=seconds --utc)" \
        --label "org.opencontainers.image.title=$(IMAGE_NAME)" \
        -f Dockerfile.alpine \
        --build-arg FROM=$(MYSQL_BASE_IMAGE) \
        --build-arg http_proxy=$(PROXY) \
        --build-arg https_proxy=$(PROXY) \
        --build-arg HTTP_PROXY=$(PROXY) \
        --build-arg HTTPS_PROXY=$(PROXY) \
        --build-arg no_proxy=$(NO_PROXY) \
        --build-arg NO_PROXY=$(NO_PROXY) \
        --build-arg ctx_base=$(MYSQL_BUILD_CTX) .
else
    docker build -t $(IMAGE) --network=host -f Dockerfile.alpine \
        --label $(LABEL) \
        --label MYSQL_VERSION=$(IMAGE_TAG) \
        --label "org.opencontainers.image.revision=$(COMMIT)" \
        --label "org.opencontainers.image.created=$(shell date --rfc-3339=seconds --utc)" \
        --label "org.opencontainers.image.title=$(IMAGE_NAME)" \
        -f Dockerfile.alpine \
        --build-arg FROM=$(MYSQL_BASE_IMAGE) \
        --build-arg ctx_base=$(MYSQL_BUILD_CTX) .
endif
ifeq ($(PUSH_IMAGE), true)
    docker push $(IMAGE)
endif
