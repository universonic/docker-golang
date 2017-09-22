Golang available as docker container is a base platform for building and running various Golang applications and frameworks on Enterprise Linux 7. Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.

## What is Go?
Go (a.k.a., Golang) is a programming language first developed at Google. It is a statically-typed language with syntax loosely derived from C, but with additional features such as garbage collection, type safety, some dynamic-typing capabilities, additional built-in types (e.g., variable-length arrays and key-value maps), and a large standard library.
* Reference: [[Wikipedia] Go Programming Language](http://en.wikipedia.org/wiki/Go_%28programming_language%29)

![Golang Logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/golang/logo.png)

## Difference with official image
Different with official image that based on Debian, this repo based on Enterprise Linux (which could be CentOS or RHEL). You can run your golang application in EL7 environment now if you would like to.

## How to Use This Image
This repository keeps compatibilities with the [official repository](https://hub.docker.com/_/golang/), which means it has the same usage with the official ones.

### Start a Go Instance in Your App
The most straightforward way to use this image is to use a Go container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project:

`FROM golang-el7:latest`

`WORKDIR /go/src/app  # It is recommended to use the default /datastore directory in the image`
`COPY . .`

`RUN go-wrapper download   # "go get -d -v ./..."`
`RUN go-wrapper install    # "go install -v ./..."`

`CMD ["go-wrapper", "run"] # ["app"]`

You can then build and run the Docker image:

`$ docker build -t <MY_GOLANG_APP>:<MY_APP_TAG> .`
`$ docker run -it --rm --name <MY_RUNNING_APP> <MY_IMAGE_ID|MY_GOLANG_APP>`

**Note**: `go-wrapper run` includes set `-x` so the binary name is printed to stderr on application startup. If this behavior is undesirable, then switching to `CMD ["app"]` (or `CMD ["myapp"]` if a [Go custom import path](https://golang.org/s/go14customimport) is in use) will silence it by running the built binary directly.

## Heads up
This repository is not an official git repo for creating Golang image. Things are tested on CentOS 7, and you can download the image from [here](https://github.com/universonic/docker-golang/releases) or [Docker Hub](https://hub.docker.com/r/universonic/golang-el7/).
