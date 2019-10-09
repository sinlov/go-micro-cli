#!/usr/bin/env bash

build_source_root=../build/micro
go_proxy_url=https://goproxy.io/

docker_temp_contain=temp-go-micro-cli
docker_temp_name=temp-micro/go-micro-cli
docker_temp_tag=lastest
docker_cp_from=/micro
docker_cp_to=../../lastest/alpine


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
        else
            pE "dockerRemoveContainSafe Not found contain [ $1 ]"
        fi
    fi
}

checkBinary git
checkBinary docker

if [[ -d "${build_source_root}" ]]; then
  cd ${build_source_root}
  git reset --hard HEAD
  git pull
else
  git clone https://github.com/micro/micro.git ${build_source_root}
  cd ${build_source_root}
fi

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

GOPROXY=${go_proxy_url} GO111MODULE=on go mod vendor
docker build -t ${docker_temp_name}:${dpcler_temp_tag} .

dockerRemoveContainSafe ${docker_temp_contain}
docker create --name ${docker_temp_contain} ${docker_temp_name}:${dpcler_temp_tag}
docker cp ${docker_temp_contain}:${docker_cp_from} ${docker_cp_to}
dockerRemoveContainSafe ${docker_temp_contain}
docker rmi -f ${docker_temp_name}:${dpcler_temp_tag}

(while :; do echo 'y'; sleep 3; done) | docker image prune