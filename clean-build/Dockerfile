# Use Go as a builder image
FROM golang:1.20-alpine AS builder

# Set environment variables for Go build
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

# Create and set the working directory
WORKDIR /app

# Copy Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy all source files into the container
COPY . .

# Build the application
RUN go build -o app .

# Use a minimal runtime image
FROM alpine:latest

# Install necessary runtime dependencies
RUN apk --no-cache add ca-certificates curl

# Set the working directory in the runtime image
WORKDIR /app

# Copy the built binary and required files from the builder image
COPY --from=builder /app/app .
COPY .env .
COPY data/ data/

# Expose the port (matching your application, e.g., 8080)
EXPOSE 8080

# Run the application
CMD ["./app"]