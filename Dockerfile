# Stage 1: Build
FROM golang:1.16-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o backend-api main.go

# Stage 2: Runtime
FROM alpine:latest
WORKDIR /app
RUN apk --no-cache add ca-certificates && \
    addgroup -g 10001 -S gogroup && \
    adduser -u 10001 -S gouser -G gogroup && \
    mkdir -p uploads && \
    chown -R gouser:gogroup /app
USER gouser
COPY --from=builder --chown=gouser:gogroup /app/backend-api .
EXPOSE 5000
CMD ["./backend-api"]