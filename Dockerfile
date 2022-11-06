
FROM golang:1.19.2-alpine3.16 as builder

WORKDIR /go/src/workspace
ADD . /go/src/workspace

RUN make all

FROM alpine3.16

WORKDIR /go/bin

COPY --from=builder /go/src/workspace/go-first .

USER nonroot:nonroot

CMD ["./go-first"]
