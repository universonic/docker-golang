# universonic/golang-el7
# Version: 1.1.0
# Author:  Alfred Chou <unioverlord@gmail.com>

FROM centos:latest AS golang_centos

# Change the following parameters as you wish. Package checksum (SHA256) can be found on:
#   <http://golang.org/dl/>
ARG GOLANG_VERSION=1.9.4
ARG GOLANG_ARCH=linux-amd64
ARG GOLANG_PKG_HASH=15b0937615809f87321a457bb1265f946f9f6e736c563d6c5e0bd2c22e44f779
ARG VENDOR_NAME="Red Hat, Inc."

USER root

# Install dependencies for cgo
RUN yum -y install glibc glibc-common kernel-headers glibc-headers glibc-devel cpp libgomp libmpc libstdc++-devel mpfr make gcc gcc-c++ && yum -y clean all

# Install golang package and dependencies
RUN set -eux; \
    yum -y install wget git && yum -y clean all; \
    url="https://golang.org/dl/go${GOLANG_VERSION}.${GOLANG_ARCH}.tar.gz"; \
    err=0; \
    for ((i=0; i<2; i++)); do \
        if [ $i -gt 0 ]; then \
            if [ $err -eq 0 ]; then \
                break; \
            fi; \
            echo "Failed verifications: ${i}/3. Trying again..." >&2; \
        fi; \
        wget -O go.tgz "$url"; \
        hash=$(sha256sum go.tgz | awk '{print $1}'); \
        if [ "${GOLANG_PKG_HASH}" != "$hash" ]; then \
            echo >&2 "Downloaded Golang package has corrupted!"; \
            err=1; \
        fi; \
    done; \
    if [ $err -gt 0 ]; then \
        echo "Failed to download Golang package. Please check your network connection and try again later."; \
        exit 1; \
    fi; \
    tar -C /usr/local -xzf go.tgz && rm -f go.tgz; \
    export PATH="/usr/local/go/bin:$PATH"; \
    go version

# Setup golang environments
COPY go-wrapper /usr/local/bin/
RUN chmod +x /usr/local/bin/go-wrapper && \
    useradd -d /datastore golang && \
    chown -R golang:golang /datastore
USER golang

ENV GOPATH /datastore
ENV PATH $GOPATH/bin:/usr/local/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH/bin"
WORKDIR $GOPATH

# Specify image metadatas
LABEL vendor ${VENDOR_NAME}
LABEL architecture x86_64
LABEL version ${GOLANG_VERSION}
LABEL summary Platform for building and running Golang ${GOLANG_VERSION} applications
LABEL description Golang ${GOLANG_VERSION} available as docker container is a base platform for building and running various Golang ${GOLANG_VERSION} applications and frameworks. Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
LABEL distribution-scope public
LABEL io.openshift.tags builder,golang,golang-${GOLANG_VERSION}
LABEL io.k8s.description Platform for building and running Golang ${GOLANG_VERSION} applications
LABEL io.k8s.display-name Golang ${GOLANG_VERSION}

# Build image with command: 'docker build --rm --squash . -t <YOUR_REPOSITORY>:<GOLANG_VERSION> -t <YOUR_REPOSITORY>:latest'
