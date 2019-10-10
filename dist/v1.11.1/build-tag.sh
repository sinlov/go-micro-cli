#!/usr/bin/env bash

build_version=v1.11.1
build_os=alpine
build_out_path=../../${build_version}/${build_os}

build_source_root=../../build/micro
go_proxy_url=https://goproxy.io/

docker_temp_contain=temp-go-micro-cli
docker_temp_name=temp-micro/go-micro-cli
docker_temp_tag=${build_version}
docker_cp_from=/micro
docker_cp_to=../../${build_version}/${build_os}


run_path=$(pwd)
shell_run_name=$(basename $0)
shell_run_path=$(cd `dirname $0`; pwd)

pV(){
    echo -e "\033[;36m$1\033[0m"
}
pI(){
    echo -e "\033[;32m$1\033[0m"
}
pD(){
    echo -e "\033[;34m$1\033[0m"
}
pW(){
    echo -e "\033[;33m$1\033[0m"
}
pE(){
    echo -e "\033[;31m$1\033[0m"
}

checkFuncBack(){
    if [[ $? -ne 0 ]]; then
        echo -e "\033[;31mRun [ $1 ] error exit code 1\033[0m"
        exit 1
    fi
}

checkBinary(){
    binary_checker=`which $1`
    checkFuncBack "which $1"
    if [[ ! -n "${binary_checker}" ]]; then
        echo -e "\033[;31mCheck binary [ $1 ] error exit\033[0m"
        exit 1
        #  else
        #    echo -e "\033[;32mCli [ $1 ] event check success\033[0m\n-> \033[;34m$1 at Path: ${evn_checker}\033[0m"
    fi
}

check_root(){
    if [[ ${EUID} != 0 ]]; then
        echo "no not root user"
    fi
}

dockerIsHasContainByName(){
    if [ ! -n $1 ]; then
        pW "Want find contain is empty"
        echo "-1"
    else
        c_status=$(docker inspect $1)
        if [ ! $? -eq 0 ]; then
            echo "1"
        else
            echo "0"
        fi
    fi
}

dockerStopContainWhenRunning(){
    if [ ! -n $1 ]; then
        pW "Want stop contain is empty"
    else
        c_status=$(docker inspect --format='{{ .State.Status}}' $1)
        if [ "running" == ${c_status} ]; then
            pD "-> docker stop contain [ $1 ]"
            docker stop $1
            checkFuncBack "docker stop $1"
        fi
    fi
}

dockerRemoveContainSafe(){
    if [ ! -n $1 ]; then
        pW "Want remove contain is empty"
    else
        has_contain=$(dockerIsHasContainByName $1)
        if [ ${has_contain} -eq 0 ];then
            dockerStopContainWhenRunning $1
            c_status=$(docker inspect --format='{{ .State.Status}}' $1)
            if [ "exited" == ${c_status} ]; then
                pD "-> docker rm contain [ $1 ]"
                docker rm $1
                checkFuncBack "docker rm $1"
            fi
            if [ "created" ==  ${c_status} ]; then
                pD "-> docker rm contain [ $1 ]"
                docker rm $1
                checkFuncBack "docker rm $1"
            fi
        else
            pE "dockerRemoveContainSafe Not found contain [ $1 ]"
        fi
    fi
}

# checkenv
checkBinary git
checkBinary docker

# pull https://github.com/micro/micro with tag start
if [[ -d "${build_source_root}" ]]; then
    cd ${build_source_root}
    git reset --hard HEAD
    git pull
else
    git clone https://github.com/micro/micro.git ${build_source_root}
    cd ${build_source_root}
fi

git checkout ${build_version}
checkFuncBack "git checkout -b ${build_version} ${build_version}"
echo "git commit code is:"
git rev-parse HEAD
# pull https://github.com/micro/micro with tag end

# replace build Dockerfile
cat > Dockerfile << EOF
FROM golang:1.13-alpine as builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk --no-cache add make git gcc libtool musl-dev
WORKDIR /
COPY . /
RUN make build

FROM alpine:latest
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk --no-cache add ca-certificates && \
    rm -rf /var/cache/apk/* /tmp/*
COPY --from=builder /micro .
ENTRYPOINT ["tail",  "-f", "/etc/alpine-release"]
EOF
echo -e "
NAME=micro
IMAGE_NAME=microhq/\$(NAME)
TAG=\$(shell git describe --abbrev=0 --tags)
CGO_ENABLED=0

all: build

vendor:
\tgo mod vendor

build:
\tGOPROXY=${go_proxy_url} go get
\tGOPROXY=${go_proxy_url} go build -a -installsuffix cgo -ldflags '-w' -o \$(NAME) ./*.go

docker:
\tdocker build -t \$(IMAGE_NAME):\$(TAG) .
\tdocker tag \$(IMAGE_NAME):\$(TAG) \$(IMAGE_NAME):latest
\tdocker push \$(IMAGE_NAME):\$(TAG)
\tdocker push \$(IMAGE_NAME):latest

vet:
\tgo vet ./...

test: vet
\tgo test -v ./...

clean:
\trm -rf ./micro

.PHONY: build clean vet test docker
" > Makefile


# build local docker image
#GOPROXY=${go_proxy_url} GO111MODULE=on go mod vendor
docker build --tag ${docker_temp_name}:${docker_temp_tag} .
checkFuncBack "docker build --tag ${docker_temp_name}:${docker_temp_tag} ."

# check hub.docker dist folder
if [[ ! -d ${build_out_path} ]]; then
    mkdir -p ${build_out_path}
fi

# start dist hub.docker
# Dockerfile
echo -e "# This dockerfile uses extends image https://hub.docker.com/sinlov/go-micro-cli
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
FROM alpine:3.10
WORKDIR /

COPY micro /
RUN apk --no-cache add ca-certificates && \\
  rm -rf /var/cache/apk/* /tmp/*

ENTRYPOINT [ \"/micro\" ]
" > ${build_out_path}/Dockerfile

pI "new tag ${build_version} Dockfile as =="
cat ${build_out_path}/Dockerfile

# README.md
echo -e "# What is go-micro-cli

docker hub see https://hub.docker.com/r/sinlov/go-micro-cli
this is fast way to run https://github.com/micro/micro cli under micro

# fast use

\`\`\`sh
docker run --rm \\
  --name micro-alpine \\
  -it sinlov/go-micro-cli:${build_version} \\
  --help
\`\`\`

# use as local cli

- version ${build_version}

\`\`\`sh
$ sudo curl -s -L --fail https://raw.githubusercontent.com/sinlov/go-micro-cli/master/${build_version}/alpine/run.sh -o /usr/local/bin/micro
$ sudo chmod +x /usr/local/bin/micro
\`\`\`

# micro

source https://github.com/micro/micro
document https://micro.mu/docs/
" > ${build_out_path}/README.md

dockerRemoveContainSafe ${docker_temp_contain}

# run image to coyp build used file
docker create --name ${docker_temp_contain} ${docker_temp_name}:${docker_temp_tag}
checkFuncBack "docker create --name ${docker_temp_contain} ${docker_temp_name}:${docker_temp_tag}"
docker cp ${docker_temp_contain}:${docker_cp_from} ${docker_cp_to}
checkFuncBack "docker cp ${docker_temp_contain}:${docker_cp_from} ${docker_cp_to}"

# clean local container and images
read -t 7 -p "Are you sure to remove container? [y/n] " remove_container_input
case $remove_container_input in
    [yY]*)
        dockerRemoveContainSafe ${docker_temp_contain}
        (while :; do echo 'y'; sleep 3; done) | docker container prune
        echo ""
        echo "-> just remove all exit container!"
    ;;
    [nN]*)
        pI "-> not remove container you can try as"
        echo "docker rm ${docker_temp_contain}"
        pI "to remove contain, but not full of contain"
        pI "if want remove full just use"
        echo "(while :; do echo 'y'; sleep 3; done) | docker container prune"
        echo ""
    ;;
    *)
        echo "-> out of time or unknow command remove container"
        pI "remove container you can try as"
        echo "docker rm ${docker_temp_contain}"
        pI "to remove contain, but not full of contain"
        pI "if want remove full just use"
        echo "(while :; do echo 'y'; sleep 3; done) | docker container prune"
        echo ""
    ;;
esac

read -t 7 -p "Are you sure to remove image prune? [y/n] " remove_image_input
case $remove_image_input in
    [yY]*)
        docker rmi -f ${docker_temp_name}:${docker_temp_tag}
        (while :; do echo 'y'; sleep 3; done) | docker image prune
        echo ""
        echo "-> just remove all prune image!"
    ;;
    [nN]*)
        pI "-> now not remove image you can try as"
        echo "docker rmi -f ${docker_temp_name}:${docker_temp_tag}"
        echo ""
        pI "if want remove full just use"
        echo "(while :; do echo 'y'; sleep 3; done) | docker image prune"
        echo ""
    ;;
    *)
        echo "-> out of time or unknow command remove image prune"
        pI "remove image you can try as"
        echo "docker rmi -f ${docker_temp_name}:${docker_temp_tag}"
        echo ""
        pI "if want remove full just use"
        echo "(while :; do echo 'y'; sleep 3; done) | docker image prune"
        echo ""
    ;;
esac
echo "=> must check out build images !"
exit 0
