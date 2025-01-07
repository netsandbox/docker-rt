#checkov:skip=CKV_DOCKER_2:Ensure that HEALTHCHECK instructions have been added to container images
#checkov:skip=CKV_DOCKER_3:Ensure that a user for the container has been created
ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL org.opencontainers.image.authors="Christian Loos <cloos@netsandbox.de>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src

# hadolint ignore=DL3003,SC2174
RUN curl -fsSL -o rt.tar.gz https://github.com/bestpractical/rt/archive/refs/heads/master.tar.gz \
  && if [[ "https://github.com/bestpractical/rt/archive/refs/heads/master.tar.gz" =~ ^https://download.bestpractical.com/pub/rt/ ]]; then \
    curl -fsSL -o rt.tar.gz.asc https://github.com/bestpractical/rt/archive/refs/heads/master.tar.gz.asc; \
    gpg --keyserver keyserver.ubuntu.com --recv-keys C49B372F2BF84A19011660270DF0A283FEAC80B2; \
    gpg --list-keys; \
    gpg --verify rt.tar.gz.asc rt.tar.gz; \
  fi \
  && tar -xzf rt.tar.gz \
  && cd rt-* \
  && echo "rt-6.0.master.$(date -I)" > .tag \
  && ./configure.ac \
    --prefix=/opt/rt \
    --enable-developer \
    --enable-externalauth \
    --enable-gd \
    --enable-gpg \
    --enable-graphviz \
    --enable-smime \
    --with-db-type=SQLite \
    --with-web-handler=standalone \
  && RT_FIX_DEPS_CMD=cpanm make fixdeps && rm -rf /root/.cpanm \
  && make install \
  && mkdir --mode=0600 --parents /opt/rt/var/data/{gpg,smime} \
  && make initialize-database \
  && cd .. && rm -rf /usr/local/src/*

WORKDIR /opt/rt
COPY RT_SiteConfig.pm etc/

VOLUME /opt/rt

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["/opt/rt/sbin/rt-server"]
