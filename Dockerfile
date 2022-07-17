FROM golang:alpine as builder
WORKDIR /usr/src
RUN apk add git build-base make nodejs npm zip
RUN npm install -g yarn
RUN git clone --recurse-submodules https://github.com/cloudreve/Cloudreve.git .
RUN git checkout 3.5.3
