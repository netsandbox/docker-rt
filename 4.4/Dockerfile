ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"
LABEL org.opencontainers.image.source="https://github.com/netsandbox/docker-rt"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
RUN curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-4.4.4.tar.gz" -o rt.tar.gz \
  && echo "34c316a4a78d7ee9b95d4391530f9bb3ff3edd99ebbebfac6354ed173e940884  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz

WORKDIR /usr/local/src/rt-4.4.4
RUN ./configure \
    --disable-gpg \
    --disable-smime \
    --enable-developer \
    --enable-externalauth \
    --enable-gd \
    --enable-graphviz \
    --with-db-type=SQLite \
    --with-web-handler=standalone \
  && make install \
  && make initdb \
  && rm -rf /usr/local/src/*

COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm

RUN chown -R www-data:www-data /opt/rt4/var/

VOLUME /opt/rt4

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt4/sbin/rt-server"]
