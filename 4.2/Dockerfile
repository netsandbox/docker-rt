ARG IMAGE=netsandbox/request-tracker-base
ARG TAG=2021-02-20
FROM ${IMAGE}:${TAG}

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"
LABEL org.opencontainers.image.source="https://github.com/netsandbox/docker-rt"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /usr/local/src
RUN curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-4.2.16.tar.gz" -o rt.tar.gz \
  && echo "1bbe619072b05efb55725c9df851363892b77ad6788dfd28eadce6a8f84a8209  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz

WORKDIR /usr/local/src/rt-4.2.16
RUN ./configure \
    --disable-gpg \
    --disable-smime \
    --enable-developer \
    --enable-gd \
    --enable-graphviz \
    --with-db-type=SQLite \
  && make install \
  && make initdb \
  && rm -rf /usr/local/src/*

COPY apache.rt.conf /etc/apache2/sites-available/rt.conf
RUN a2dissite 000-default.conf && a2ensite rt.conf

RUN chown -R www-data:www-data /opt/rt4/var/

COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm

VOLUME /opt/rt4

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["apache2-foreground"]
