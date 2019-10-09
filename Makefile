.PHONY: test check clean dist

TOP_DIR := $(shell pwd)

ROOT_BUILD_PATH ?= ./build
ROOT_LOG_PATH ?= ./log
ROOT_DIST ?= ./out

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

help:
	@echo "make all ~> fast build"
	@echo ""
	@echo "make clean - remove binary file and log files"
	@echo ""
	@echo "make buildLatestAlpine ~> build latest alpine"