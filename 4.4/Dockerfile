ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"
LABEL org.opencontainers.image.source="https://github.com/netsandbox/docker-rt"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
# hadolint ignore=DL3003
RUN curl -fsSL "https://download.bestpractical.com/pub/rt/release/rt-4.4.5.tar.gz" -o rt.tar.gz \
  && echo "c3025d5fe5bf5479d07318652fa904f4940f5172801a2aae4e397779b519556e  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && cd rt-4.4.5 \
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

WORKDIR /opt/rt4
COPY RT_SiteConfig.pm etc/

VOLUME /opt/rt4

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt4/sbin/rt-server"]
