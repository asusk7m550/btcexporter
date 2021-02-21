# Stage 1 - build the service
FROM asusk7m550/alpine-kafka:latest

# Set the workdir
WORKDIR /go/src/app

# Copy files
COPY . .

# Get the dependencies
RUN go get -tags integration -t -v -d ./...

# Compile statically linked version of package
RUN GOOS=linux GOARCH=amd64 go build -tags musl

# Stage 2 - Create the image
FROM alpine:latest

# Copy the files
COPY --from=0 /go/src/app/app /go/bin/service
RUN mkdir /app
WORKDIR /app
COPY addresses.txt /app

ENV PORT 9019

ENTRYPOINT ["/go/bin/service"]
