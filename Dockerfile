# Multi-stage Dockerfile for Open-Source Pulse
# Build context: ../pulse (or the pulse repository root)

FROM golang:1.25-alpine AS builder

RUN apk add --no-cache git ca-certificates

WORKDIR /build

# Cache modules
COPY go.mod go.sum* ./
RUN go mod download

# Copy source code
COPY . .

ARG VERSION=dev
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags "-s -w -X main.version=${VERSION}" \
    -o /out/pulse ./cmd/pulse

# -----------------------------------------------------------------------------
# Runtime: Pulse Core
# -----------------------------------------------------------------------------
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /

COPY --from=builder /out/pulse /pulse
COPY --from=builder /build/migrations /migrations
COPY --from=builder /build/configs /configs

USER nonroot:nonroot

EXPOSE 32001 32003 32011

ENTRYPOINT ["/pulse"]
CMD ["dev", "--config", "/configs/dev.yaml"]
