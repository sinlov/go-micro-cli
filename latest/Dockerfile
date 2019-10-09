# This dockerfile uses extends image https://hub.docker.com/sinlov/go-micro-cli
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
FROM alpine:3.10

ADD ../dist/micro/last/micro /micro

WORKDIR /
ENTRYPOINT [ "/micro" ]
