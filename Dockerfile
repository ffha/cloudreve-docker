FROM golang:alpine as builder
WORKDIR /usr/src
RUN apk add git build-base make nodejs npm zip
RUN npm install -g yarn
RUN git clone --recurse-submodules https://github.com/cloudreve/Cloudreve.git .
RUN git checkout 3.5.3
ARG VERSION=$(git describe --tags)
ARG COMMIT_SHA=$(git rev-parse --short HEAD)
WORKDIR /usr/src/assets
RUN yarn
RUN yarn build
WORKDIR /usr/src
RUN go build -a -o cloudreve -ldflags "-s -w -X 'github.com/cloudreve/Cloudreve/v3/pkg/conf.BackendVersion=$VERSION' -X 'github.com/cloudreve/Cloudreve/v3/pkg/conf.LastCommit=$COMMIT_SHA'"
FROM alpine as runner
LABEL org.opencontainers.image.description Cloudreve-on-docker
RUN apk add tini
WORKDIR /app
COPY --from=builder /usr/src/cloudreve /app/cloudreve
ENTRYPOINT ["/sbin/tini", "--"]
CMD /app/cloudreve
