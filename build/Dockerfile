FROM golang:1.14.2-alpine3.11 as builder

ENV GO111MODULE=on

ADD . /go/src/example.com

WORKDIR /go/src/example.com/cmd/app

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o run .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /usr/local/bin

COPY --from=builder /go/src/example.com/cmd/app/run .

CMD ["./run"]