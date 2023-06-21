FROM golang:1.20-alpine3.18 as builder

WORKDIR /go/src/workspace
ADD . /go/src/workspace

RUN apk add --no-cache alpine-sdk && make all

FROM alpine:3.18

RUN apk update && apk add --no-cache ca-certificates

WORKDIR /go/bin

COPY --from=builder /go/src/workspace/go-first .

USER 1001

CMD ["./go-first"]
