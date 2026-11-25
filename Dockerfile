ARG RESTY_IMAGE_BASE="openresty/openresty"
ARG RESTY_IMAGE_TAG="1.31.9.1-alpine-fat"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

ARG GM_VERSION="1.3.49"
ARG GM_SHA256="7efa070dc31116b4315061b39f84bc7181e8b060bf61214ec9af851131af9c81"

LABEL maintainer="kuwork <kuwork@126.com>" \
    architecture="alpine" \
    openresty-version="1.31.9.1" \
    openssl-version="3.5.8" \
    pcre-version="10.49" \
    graphicsmagick-version="${GM_VERSION}" \
    graphicsmagick-sha256="${GM_SHA256}" \
    luarocks-version="3.13.0" \
    alpine-version="3.24.3" \
    org.opencontainers.image.title="openresty-gm" \
    org.opencontainers.image.description="Openresty with GraphicsMagick on Alpine Linux" \
    org.opencontainers.image.authors="kuwork <kuwork@126.com>" \
    org.opencontainers.image.vendor="K.W. Systems" \
    org.opencontainers.image.version="1.0.0" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

ARG RESTY_J="4"
ENV TEMP_DIR=/tmp/
ENV PKGNAME=graphicsmagick
ENV GM_VERSION=${GM_VERSION}
ENV PKGSOURCE=https://downloads.sourceforge.net/project/$PKGNAME/$PKGNAME/$GM_VERSION/GraphicsMagick-$GM_VERSION.tar.xz
ENV GM_PATH=$TEMP_DIR/GraphicsMagick-$GM_VERSION

WORKDIR $TEMP_DIR
RUN apk add --no-cache \
        g++ \
        gcc \
        make \
        curl \
        xz \
        libjpeg-turbo-dev \
        libpng-dev \
        libtool \
        libgomp \
        yasm \
        ffmpeg && \
    curl -fSL "$PKGSOURCE" -o "$GM_PATH.tar.xz" && \
    echo "${GM_SHA256}  ${GM_PATH}.tar.xz" | sha256sum -c - && \
    tar xJf "$GM_PATH.tar.xz" && \
    cd "$GM_PATH" && \
    ./configure && \
    make -j${RESTY_J} && \
    make -j${RESTY_J} install && \
    cd .. && \
    rm -rf "$GM_PATH.tar.xz" "$GM_PATH" && \
    apk del g++ gcc make

# Copy nginx configuration files
#COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
#COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
