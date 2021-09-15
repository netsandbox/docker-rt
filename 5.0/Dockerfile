ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"
LABEL org.opencontainers.image.source="https://github.com/netsandbox/docker-rt"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
RUN curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-5.0.1.tar.gz" -o rt.tar.gz \
  && echo "6c181cc592c48a2cba8b8df1d45fda0938d70f84ceeba1afc436f16a6090f556  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz

WORKDIR /usr/local/src/rt-5.0.1
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

COPY RT_SiteConfig.pm /opt/rt5/etc/RT_SiteConfig.pm

RUN chown -R www-data:www-data /opt/rt5/var/

VOLUME /opt/rt5

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt5/sbin/rt-server"]
