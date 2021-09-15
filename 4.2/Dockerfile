ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"
LABEL org.opencontainers.image.source="https://github.com/netsandbox/docker-rt"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
RUN curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-4.2.17.tar.gz" -o rt.tar.gz \
  && echo "177b7e004b90ec7faaac8e21e11b7bc33bd129aba2d512e4b011c37995f8480c  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz

WORKDIR /usr/local/src/rt-4.2.17
RUN ./configure \
    --disable-gpg \
    --disable-smime \
    --enable-developer \
    --enable-gd \
    --enable-graphviz \
    --with-db-type=SQLite \
    --with-web-handler=standalone \
  && make install \
  && make initdb \
  && rm -rf /usr/local/src/*

COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm

VOLUME /opt/rt4

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt4/sbin/rt-server"]
