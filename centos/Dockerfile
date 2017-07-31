# golang 1.8.3
# Version: 1.0.0.a
# Author: Alfred Chou

FROM centos:latest

# Change the following parameters as you wish. Package hash (SHA256) can be found on:
#   * http://golang.org/dl/
ARG GOLANG_VERSION=1.8.3
ARG GOLANG_ARCH=linux-amd64
ARG GOLANG_PKG_HASH=1862f4c3d3907e59b04a757cfda0ea7aa9ef39274af99a784f5be843c80c6772
ARG VENDOR_NAME="Red Hat, Inc."

USER root

# Install dependencies for cgo
RUN yum -y install glibc glibc-common kernel-headers glibc-headers glibc-devel cpp libgomp libmpc libstdc++-devel mpfr make gcc gcc-c++ && yum -y clean all

# Install golang environments
RUN set -eux; \
        yum -y install wget git && yum -y clean all; \
        url="https://golang.org/dl/go${GOLANG_VERSION}.${GOLANG_ARCH}.tar.gz"; \
        wget -O go.tgz "$url"; \
        hash=$(sha256sum go.tgz | awk '{print $1}'); \
        if [ "${GOLANG_PKG_HASH}" != "$hash" ]; then \
            echo >&2 "The Golang package has corrupted, try again later."; \
            exit 2; \
        fi; \
        tar -C /usr/local -xzf go.tgz && rm go.tgz; \
        mkdir /datastore; \
        export PATH="/usr/local/go/bin:$PATH"; \
        go version

ENV GOPATH /datastore
ENV PATH $GOPATH/bin:/usr/local/bin:/usr/local/go/bin:$PATH

COPY go-wrapper /usr/local/bin/
RUN chmod +x /usr/local/bin/go-wrapper && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

LABEL vendor ${VENDOR_NAME}
LABEL architecture x86_64
LABEL version 1.8.3
LABEL summary Platform for building and running Golang ${GOLANG_VERSION} applications
LABEL description Golang ${GOLANG_VERSION} available as docker container is a base platform for building and running various Golang ${GOLANG_VERSION} applications and frameworks. Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LABEL distribution-scope public
LABEL io.openshift.tags builder,golang,golang-1.8.3
LABEL io.k8s.description Platform for building and running Golang ${GOLANG_VERSION} applications
LABEL io.k8s.display-name Golang ${GOLANG_VERSION}

# Build image with command: 'docker build --squash . -t golang:<GOLANG_VERSION>'
