FROM golang:1.16-buster as builder

# Create and change to the app directory.
WORKDIR /app

# RUN curl -L https://packagecloud.io/golang-migrate/migrate/gpgkey | apt-key add -
# RUN echo "deb https://packagecloud.io/golang-migrate/migrate/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/migrate.list
# RUN apt-get update
# RUN apt-get install -y migrate

# Retrieve application dependencies.
# This allows the container build to reuse cached dependencies.
# Expecting to copy go.mod and if present go.sum.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY . ./

# Build the binary.
RUN go build -v -o server

# Use the official Debian slim image for a lean production container.
# https://hub.docker.com/_/debian
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM debian:buster-slim

RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# RUN curl -L https://packagecloud.io/golang-migrate/migrate/gpgkey | apt-key add -
# RUN echo "deb https://packagecloud.io/golang-migrate/migrate/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/migrate.list
# RUN apt-get update
RUN apt-get install -y migrate
RUN migrate --version

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /app/server

# Run the web service on container startup.
CMD ["/app/server"]
