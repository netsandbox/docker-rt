#checkov:skip=CKV_DOCKER_2:Ensure that HEALTHCHECK instructions have been added to container images
#checkov:skip=CKV_DOCKER_3:Ensure that a user for the container has been created
ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL org.opencontainers.image.authors="Christian Loos <cloos@netsandbox.de>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN gpg --keyserver keyserver.ubuntu.com --recv-keys C49B372F2BF84A19011660270DF0A283FEAC80B2 \
  && gpg --list-keys

WORKDIR /usr/local/src

# hadolint ignore=DL3003,SC2174
RUN curl -fsSL \
    -o rt.tar.gz https://download.bestpractical.com/pub/rt/release/rt-5.0.7.tar.gz \
    -o rt.tar.gz.asc https://download.bestpractical.com/pub/rt/release/rt-5.0.7.tar.gz.asc \
  && gpg --verify rt.tar.gz.asc rt.tar.gz \
  && tar -xzf rt.tar.gz \
  && cd rt-5.0.7 \
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
