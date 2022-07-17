FROM golang:alpine as builder
WORKDIR /usr/src
RUN apk add git build-base make
RUN git clone --recurse-submodules https://github.com/cloudreve/Cloudreve.git .
RUN git checkout 3.5.3
RUN ./build.sh -r
