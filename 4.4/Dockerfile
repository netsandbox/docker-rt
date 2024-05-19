#checkov:skip=CKV_DOCKER_2:Ensure that HEALTHCHECK instructions have been added to container images
#checkov:skip=CKV_DOCKER_3:Ensure that a user for the container has been created
ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL org.opencontainers.image.authors="Christian Loos <cloos@netsandbox.de>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
# hadolint ignore=DL3003,SC2174
RUN curl -fsSL "https://download.bestpractical.com/pub/rt/release/rt-4.4.7.tar.gz" -o rt.tar.gz \
  && echo "47af1651d5df3f25b6374ff6c1da71c66202d61919d9431c17259fa3df69ae59  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && cd rt-4.4.7 \
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
  && mkdir --mode=0600 --parents /opt/rt4/var/data/{gpg,smime} \
  && make initialize-database \
  && cd .. && rm -rf /usr/local/src/*

WORKDIR /opt/rt4
COPY RT_SiteConfig.pm etc/

VOLUME /opt/rt4

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt4/sbin/rt-server"]
