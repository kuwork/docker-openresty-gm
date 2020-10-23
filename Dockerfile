ARG RESTY_IMAGE_BASE="openresty/openresty"
ARG RESTY_IMAGE_TAG="1.15.8.3-1-alpine-fat-nosse42"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="kuwork <kuwork@126.com>" \
    architecture="alpine" \
    openresty-version="1.15.8.3" \
    graphicsmagick-version="1.3.35" \
    alpine-version="3.11" \
    build="17-Apr-2020" \
    org.opencontainers.image.title="openresty-gm" \
    org.opencontainers.image.description="Openresty with GraphicsMagick on Alpine Linux" \
    org.opencontainers.image.authors="kuwork <kuwork@126.com>" \
    org.opencontainers.image.vendor="K.W. Systems" \
    org.opencontainers.image.version="v1.0" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE
ENV TEMP_DIR=/tmp/
ENV PKGNAME=graphicsmagick
ENV GM_VERSION=1.3.35
ENV PKGSOURCE=https://pilotfiber.dl.sourceforge.net/project/$PKGNAME/$PKGNAME/$GM_VERSION/GraphicsMagick-$GM_VERSION.tar.gz
ENV GM_PATH=$TEMP_DIR/GraphicsMagick-$GM_VERSION

WORKDIR $TEMP_DIR
RUN apk add --update g++ \
                     gcc \
                     make \
                     curl \
                     libjpeg-turbo-dev \
                     libpng-dev \
                     libtool \
                     libgomp && \
    curl -fSL $PKGSOURCE -o $GM_PATH.tar.gz && \
    tar xzf $GM_PATH.tar.gz && \
    cd $GM_PATH && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf $GM_PATH.tar.gz &&\
    apk del g++ \
            gcc \
            make 
            
 # Copy nginx configuration files
#COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
#COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT

