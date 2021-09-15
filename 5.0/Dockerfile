ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"
LABEL org.opencontainers.image.source="https://github.com/netsandbox/docker-rt"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
# hadolint ignore=DL3003
RUN curl -fsSL "https://download.bestpractical.com/pub/rt/release/rt-5.0.2.tar.gz" -o rt.tar.gz \
  && echo "df915ae809277564d9b8a7192ced2517cf6bed6c0301786b69562c0ea9dd9e86  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && cd rt-5.0.2 \
  && ./configure \
    --disable-gpg \
    --disable-smime \
    --enable-developer \
    --enable-externalauth \
    --enable-gd \
    --enable-graphviz \
    --with-db-type=SQLite \
    --with-web-handler=standalone \
  && make install \
  && make initialize-database \
  && cd .. && rm -rf /usr/local/src/*

WORKDIR /opt/rt5
COPY RT_SiteConfig.pm etc/

VOLUME /opt/rt5

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt5/sbin/rt-server"]
