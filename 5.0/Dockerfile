#checkov:skip=CKV_DOCKER_2:Ensure that HEALTHCHECK instructions have been added to container images
#checkov:skip=CKV_DOCKER_3:Ensure that a user for the container has been created
ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL org.opencontainers.image.authors="Christian Loos <cloos@netsandbox.de>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
# hadolint ignore=DL3003,SC2174
RUN curl -fsSL "https://download.bestpractical.com/pub/rt/release/rt-5.0.6.tar.gz" -o rt.tar.gz \
  && echo "b556bedd2b4a356ec9f54eb673ff250ae9100347a04d11e34637e3fdd3efdddb  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && cd rt-5.0.6 \
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
