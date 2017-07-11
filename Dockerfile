FROM sdhibit/alpine-runit:3.6
MAINTAINER Steve Hibit <sdhibit@gmail.com>

ARG PKG_NAME="mono"
ARG PKG_VER="5.0.1.1"
ARG APP_BASEURL="http://download.mono-project.com/sources/mono"
ARG APP_PKGNAME="mono-${PKG_VER}.tar.bz2"
ARG APP_URL="${APP_BASEURL}/${APP_PKGNAME}"

#Build mono
# install build packages
RUN apk --update upgrade \
 && apk add --no-cache --virtual=build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    zlib-dev \
    libgdiplus \
    libgdiplus-dev \
    python2 \
    linux-headers \
    paxmark \
    autoconf \
    automake \
    libtool \
    cmake \
    tar \
    gcc \
    build-base \
 && mkdir -p /tmp/mono \
 && curl -kL ${APP_URL} | tar -xj -C /tmp/mono --strip-components=1 \
 && cd /tmp/mono \
 && sed -i 's|$mono_libdir/||g' data/config.in \
 && sed -i '/exec "/ i\paxmark mr "$(readlink -f "$MONO_EXECUTABLE")"' \
    runtime/mono-wrapper.in \
 && export CFLAGS="$CFLAGS -fno-strict-aliasing" \
 && ./autogen.sh \
        --build=$CBUILD \
        --host=$CHOST \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --disable-rpath \
        --disable-boehm \
        --enable-parallel-mark \
        --with-mcs-docs=no \
        --without-sigaltstack \
 && make \
 && make install \
 && apk del --purge build-dependencies \
 && rm /usr/lib/*.la \
 && rm /usr/lib/libMonoSupportW.* \
 && rm -r /usr/lib/mono/*/Mono.Security.Win32* \
 && cd /tmp \
 && rm -rf /tmp/* 
