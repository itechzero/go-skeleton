
FROM golang:1.19.2-alpine3.16 as builder

WORKDIR /go/src/workspace
ADD . /go/src/workspace

RUN apk add --no-cache alpine-sdk && make all

FROM alpine:3.16

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

WORKDIR /go/bin

COPY --from=builder /go/src/workspace/go-first .

USER 1001

CMD ["./go-first"]
