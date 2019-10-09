FROM golang:alpine as builder
MAINTAINER Jack Murdock <jack_murdock@comcast.com>

WORKDIR /go/src/github.com/kcajmagic/testing
ARG VERSION=unknown
ARG GITCOMMIT=unknown
ARG BUILDTIME=unknown

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

COPY . .
RUN GO111MODULE=on go build \
  -o testing_linux_amd64 \
  -ldflags "-X 'main.BuildTime=${BUILDTIME}' -X main.GitCommit=${GITCOMMIT} -X main.Version=${VERSION}"

FROM alpine

RUN apk --no-cache add ca-certificates

EXPOSE 8080

COPY --from=builder /go/src/github.com/kcajmagic/testing/testing_linux_amd64 /
ENTRYPOINT ["/testing_linux_amd64"]

