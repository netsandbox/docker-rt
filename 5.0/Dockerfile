ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"
LABEL org.opencontainers.image.source="https://github.com/netsandbox/docker-rt"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
# hadolint ignore=DL3003,SC2174
RUN curl -fsSL "https://download.bestpractical.com/pub/rt/release/rt-5.0.3.tar.gz" -o rt.tar.gz \
  && echo "e23aee3cb291ccad5e521aeabe0fcd2f076bcfa8b7f801af498a7505e53d8441  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && cd rt-5.0.3 \
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
