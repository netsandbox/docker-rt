ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL org.opencontainers.image.authors="Christian Loos <cloos@netsandbox.de>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
# hadolint ignore=DL3003,SC2174
RUN curl -fsSL "https://download.bestpractical.com/pub/rt/release/rt-5.0.5.tar.gz" -o rt.tar.gz \
  && echo "90f845daaa436198c334b6e9cf5afb1df9f4445dcc165d0bcae35de9eb9be8ef  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && cd rt-5.0.5 \
  && ./configure \
    --enable-developer \
    --enable-externalauth \
    --enable-gd \
    --enable-gpg \
    --enable-graphviz \
    --enable-smime \
    --with-db-type=SQLite \
    --with-web-handler=standalone \
  && make install \
  && mkdir --mode=0600 --parents /opt/rt5/var/data/{gpg,smime} \
  && make initialize-database \
  && cd .. && rm -rf /usr/local/src/*

WORKDIR /opt/rt5
COPY RT_SiteConfig.pm etc/

VOLUME /opt/rt5

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt5/sbin/rt-server"]
