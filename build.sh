#! /bin/bash
set -e

RESTY_IMAGE_BASE="${RESTY_IMAGE_BASE:-docker.m.daocloud.io/library/alpine}"
RESTY_OPENSSL_URL_BASE="${RESTY_OPENSSL_URL_BASE:-https://www.openssl.org/source}"
RESTY_PCRE_URL_BASE="${RESTY_PCRE_URL_BASE:-https://ghfast.top/https://github.com/PCRE2Project/pcre2/releases/download}"

docker build \
  --build-arg RESTY_IMAGE_BASE="${RESTY_IMAGE_BASE}" \
  --build-arg RESTY_OPENSSL_URL_BASE="${RESTY_OPENSSL_URL_BASE}" \
  --build-arg RESTY_PCRE_URL_BASE="${RESTY_PCRE_URL_BASE}" \
  --build-arg RESTY_J=4 \
  -f alpine/Dockerfile \
  -t kuwork/openresty:alpine .

docker build \
  --build-arg RESTY_FAT_IMAGE_BASE=kuwork/openresty \
  --build-arg RESTY_FAT_IMAGE_TAG=alpine \
  --build-arg RESTY_LUAROCKS_VERSION="3.13.0" \
  -f alpine/Dockerfile.fat \
  -t kuwork/openresty:alpine-fat .

docker build \
  --build-arg RESTY_IMAGE_BASE=kuwork/openresty \
  --build-arg RESTY_IMAGE_TAG=alpine-fat \
  --build-arg RESTY_J=4 \
  -f ./Dockerfile \
  -t kuwork/openresty:alpine-fat-gm .
