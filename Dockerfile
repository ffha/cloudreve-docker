FROM golang:alpine as builder
WORKDIR /usr/src
ARG COMMIT_SHA=$(git rev-parse --short HEAD)
RUN apk add git build-base make nodejs npm zip
RUN npm install -g yarn
RUN git clone --recurse-submodules https://github.com/cloudreve/Cloudreve.git .
RUN git checkout 3.5.3
WORKDIR /usr/src/assets
RUN yarn
RUN yarn build
WORKDIR /usr/src
