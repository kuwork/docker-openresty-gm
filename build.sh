#! /bin/bash
docker build --build-arg RESTY_J=4 -f alpine/Dockerfile -t kuwork/openresty:alpine .
docker build --build-arg RESTY_IMAGE_BASE=kuwork/openresty --build-arg RESTY_LUAROCKS_VERSION="3.4.0" -f alpine/Dockerfile.fat -t kuwork/openresty:alpine-fat .
docker build --build-arg RESTY_IMAGE_BASE=kuwork/openresty --build-arg RESTY_IMAGE_TAG=alpine-fat -f ./Dockerfile -t kuwork/openresty:alpine-fat-gm .