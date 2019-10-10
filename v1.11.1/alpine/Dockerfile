# This dockerfile uses extends image https://hub.docker.com/sinlov/go-micro-cli
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
FROM alpine:3.10
WORKDIR /

COPY micro /
RUN apk --no-cache add ca-certificates && \
  rm -rf /var/cache/apk/* /tmp/*

ENTRYPOINT [ "/micro" ]

