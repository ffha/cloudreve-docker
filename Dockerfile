FROM golang:alpine as builder
WORKDIR /usr/src
RUN apk add git build-base make
RUN git clone https://github.com/cloudreve/Cloudreve .
