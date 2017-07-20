FROM sdhibit/alpine-runit:3.6-glibc
MAINTAINER Steve Hibit <sdhibit@gmail.com>

ARG PKG_NAME="mono"
ARG PKG_VER="5.0.0.100-2"
ARG APP_BASEURL="https://archive.archlinux.org/packages/m/mono"
ARG APP_PKGNAME="${PKG_NAME}-${PKG_VER}-x86_64.pkg.tar.xz"
ARG APP_URL="${APP_BASEURL}/${APP_PKGNAME}"

RUN apk --update upgrade \
 && apk add --no-cache --virtual=build-dependencies \
    ca-certificates \
    wget \
    tar \
    xz \
 && wget ${APP_URL} -O /tmp/mono.pkg.tar.xz \
 && tar -xJf /tmp/mono.pkg.tar.xz \
 && apk del --purge build-dependencies \
 && rm -rf /tmp/* \
 && update-ca-certificates \
 && cert-sync /etc/ssl/certs/ca-certificates.crt
