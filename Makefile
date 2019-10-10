.PHONY: test check clean dist

TOP_DIR := $(shell pwd)

ROOT_SWITCH_TAG := v1.11.1

ROOT_BUILD_PATH ?= ./build
ROOT_LOG_PATH ?= ./log
ROOT_DIST ?= ./out

TEST_TAG_BUILD_IMAGE_NAME ?= micro/go-micro-cli
TEST_TAG_BUILD_CONTAINER_NAME ?= test-micro-go-micro-cli

all: buildLatestAlpine

checkBuildPath:
	@if [ ! -d ${ROOT_BUILD_PATH} ]; then mkdir -p ${ROOT_BUILD_PATH} && echo "~> mkdir ${ROOT_BUILD_PATH}"; fi

checkDistPath:
	@if [ ! -d ${ROOT_DIST} ]; then mkdir -p ${ROOT_DIST} && echo "~> mkdir ${ROOT_DIST}"; fi

cleanBuild:
	@if [ -d ${ROOT_BUILD_PATH} ]; then rm -rf ${ROOT_BUILD_PATH} && echo "~> cleaned ${ROOT_BUILD_PATH}"; else echo "~> has cleaned ${ROOT_BUILD_PATH}"; fi

cleanLog:
	@if [ -d ${ROOT_LOG_PATH} ]; then rm -rf ${ROOT_LOG_PATH} && echo "~> cleaned ${ROOT_LOG_PATH}"; else echo "~> has cleaned ${ROOT_LOG_PATH}"; fi

cleanDist:
	@if [ -d ${ROOT_DIST} ]; then rm -rf ${ROOT_DIST} && echo "~> cleaned ${ROOT_DIST}"; else echo "~> has cleaned ${ROOT_DIST}"; fi

dockerCleanImages:
	(while :; do echo 'y'; sleep 3; done) | docker image prune

clean: cleanBuild cleanLog
	@echo "~> clean finish"

buildLatestAlpine: checkBuildPath
	cd dist && bash build-alpine.sh

buildTag:
	cd dist/$(ROOT_SWITCH_TAG) && bash build-tag.sh

testTagBuild:
	cd $(ROOT_SWITCH_TAG)/apline && docker build -t $(TEST_TAG_BUILD_IMAGE_NAME):test-$(ROOT_SWITCH_TAG) .
	docker run --rm --name $(TEST_TAG_BUILD_CONTAINER_NAME) $(TEST_TAG_BUILD_IMAGE_NAME):test-$(ROOT_SWITCH_TAG) --help

testRemoveTagBuild:
	docker rmi -f $(TEST_TAG_BUILD_IMAGE_NAME):test-$(ROOT_SWITCH_TAG)

help:
	@echo "make all ~> fast build"
	@echo ""
	@echo "make clean - remove binary file and log files"
	@echo ""
	@echo "make buildLatestAlpine ~> build latest alpine"
	@echo "make buildTag ~> build tag as $(ROOT_SWITCH_TAG) alpine"