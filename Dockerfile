# Build
FROM golang:1.16-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download
RUN go build -o main .
# Run
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 5000
CMD ["./main"]
