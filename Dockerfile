FROM openresty/openresty:1.15.8.3-1-alpine-fat-nosse42

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
                     wget \
                     libjpeg-turbo-dev \
                     libpng-dev \
                     libtool \
                     libgomp && \
    wget --no-check-certificate $PKGSOURCE -O $GM_PATH.tar.gz && \
    tar xzf $GM_PATH.tar.gz && \
    cd $GM_PATH && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf $GM_PATH.tar.gz &&\
    apk del g++ \
            gcc \
            make \
            lzip \
            wget

