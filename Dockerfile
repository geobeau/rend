FROM golang:1.13 AS builder


LABEL maintener="nosql-team@criteo.com"

WORKDIR /app


# Cache depenencies first
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the project
COPY . .
RUN mkdir bin ; cd bin ; \
    CGO_ENABLED=0 GOOS=linux find ../app -name '*.go' -exec go build {} \;


FROM alpine:3.11

LABEL maintener="nosql-team@criteo.com"
COPY --from=builder /app/bin/ .
WORKDIR /

CMD ["/bin/sh"]