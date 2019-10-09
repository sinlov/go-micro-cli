# This dockerfile uses extends image https://hub.docker.com/sinlov/go-micro-cli
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
FROM alpine:3.10
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
#RUN apk --no-cache add make git gcc libtool musl-dev
RUN apk --no-cache add ca-certificates && \
    rm -rf /var/cache/apk/* /tmp/*

WORKDIR /
COPY latest/alpine/micro /

ENTRYPOINT [ "/micro" ]
