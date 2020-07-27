FROM 0x01be/ninja as ninja

FROM alpine:3.12.0 as builder

ENV VERSION 2.29.3

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    git \
    tar \
    build-base \
    cmake \
    autoconf \
    libmspack-dev \
    perl \
    python2 \
    ruby \
    cairo-dev \
    libgcrypt-dev \
    gtk+3.0-dev \
    jpeg-dev \
    libsoup-dev \
    libwebp-dev \
    ccache \
    libwpe-dev \
    libwpebackend-fdo-dev \
    libxslt-dev \
    libsecret-dev \
    gobject-introspection-dev \
    libtasn1-dev \
    binutils-gold \
    m4 \
    gnupg \
    automake \
    coreutils \
    libxt-dev \
    libnotify-dev \
    hyphen-dev \
    openjpeg-dev \
    woff2-dev \
    bubblewrap \
    libseccomp-dev \
    xdg-dbus-proxy \
    gst-plugins-base-dev \
    gperf \
    ruby-dev \
    mesa-dev \
    mesa-gles

RUN gem install json

COPY --from=ninja /opt/ninja/ /opt/ninja/
ENV PATH $PATH:/opt/ninja/

RUN git clone https://github.com/AbiWord/enchant /enchant

WORKDIR /enchant

RUN ./bootstrap
RUN ./configure
RUN make
RUN make install

RUN mkdir /webkitgtk

ADD https://webkitgtk.org/releases/webkitgtk-$VERSION.tar.xz /webkitgtk/webkitgtk-$VERSION.tar.xz
 
WORKDIR /webkitgtk
RUN tar -xf webkitgtk-$VERSION.tar.xz

WORKDIR /webkitgtk/webkitgtk-$VERSION

RUN cmake -DPORT=GTK -DUSE_SYSTEMD=OFF -GNinja
RUN ninja
RUN ninja install

