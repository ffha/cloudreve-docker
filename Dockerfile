# the frontend builder
# cloudreve need node.js 16* to build frontend,
# separate build step and custom image tag will resolve this
FROM node:16-alpine as cloudreve_frontend_builder

RUN apk update \
    && apk add --no-cache wget curl git zip bash \
    && git clone --recurse-submodules https://github.com/cloudreve/Cloudreve.git /cloudreve_frontend \
    && git checkout 3.6.2

# build frontend assets using build script, make sure all the steps just follow the regular release
WORKDIR /cloudreve_frontend
ENV GENERATE_SOURCEMAP false
RUN chmod +x ./build.sh && ./build.sh -a


# the backend builder
# cloudreve backend needs golang 1.18* to build
FROM golang:1.18-alpine as cloudreve_backend_builder

# install dependencies and build tools
RUN apk update \
    # install dependencies and build tools
    && apk add --no-cache wget curl git clang15 llvm15 build-base gcc abuild binutils binutils-doc gcc-doc zip bash \
    && ln -sf /usr/bin/lld /usr/bin/ld \
    && git clone --recurse-submodules https://github.com/cloudreve/Cloudreve.git /cloudreve_backend \
    && git checkout 3.6.2
ENV CC=clang AR=llvm-ar CXX=clang++
WORKDIR /cloudreve_backend
COPY --from=cloudreve_frontend_builder /cloudreve_frontend/assets.zip ./
RUN chmod +x ./build.sh && ./build.sh -c


# TODO: merge the frontend build and backend build into a single one image
# the final published image
FROM alpine:latest

WORKDIR /cloudreve
COPY --from=cloudreve_backend_builder /cloudreve_backend/cloudreve ./cloudreve

RUN apk update \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && chmod +x ./cloudreve \
    && mkdir -p /data/aria2 \
    && chmod -R 766 /data/aria2

EXPOSE 5212
VOLUME ["/cloudreve/uploads", "/cloudreve/avatar", "/data"]

ENTRYPOINT ["./cloudreve"]
