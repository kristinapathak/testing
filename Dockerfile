FROM golang:alpine as builder
MAINTAINER Jack Murdock <jack_murdock@comcast.com>

WORKDIR /go/src/github.com/kcajmagic/testing

RUN apk add --update git curl
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

COPY . .
RUN dep ensure
COPY . .

RUN go build -o testing_linux_amd64 github.com/kcajmagic/testing

FROM alpine

RUN apk --no-cache add ca-certificates

EXPOSE 8080

COPY --from=builder /go/src/github.com/kcajmagic/testing/testing_linux_amd64 /
ENTRYPOINT ["/testing_linux_amd64"]

