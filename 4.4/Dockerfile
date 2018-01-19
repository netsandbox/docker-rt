FROM netsandbox/request-tracker-base

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"

ENV RT_VERSION 4.4.2
ENV RT_SHA b2e366e18c8cb1dfd5bc6c46c116fd28cfa690a368b13fbf3131b21a0b9bbe68

RUN cd /usr/local/src \
  && curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-${RT_VERSION}.tar.gz" -o rt.tar.gz \
  && echo "${RT_SHA}  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && rm rt.tar.gz \
  && cd "rt-${RT_VERSION}" \
  && ./configure \
    --disable-gpg \
    --disable-smime \
    --enable-developer \
    --enable-gd \
    --enable-graphviz \
    --with-db-type=SQLite \
  && make install \
  && make initdb

COPY apache.rt.conf /etc/apache2/sites-available/rt.conf
RUN a2dissite 000-default.conf && a2ensite rt.conf

RUN chown -R www-data:www-data /opt/rt4/var/

COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm

# /etc/apache2/envvars isn't sourced by default
ENV APACHE_LOCK_DIR=/var/lock/apache2 \
  APACHE_LOG_DIR=/var/log/apache2 \
  APACHE_PID_FILE=/var/run/apache2/apache2.pid \
  APACHE_RUN_GROUP=www-data \
  APACHE_RUN_USER=www-data

VOLUME /opt/rt4

EXPOSE 80
CMD ["/usr/sbin/apache2","-DFOREGROUND"]
