FROM netsandbox/request-tracker-base

LABEL maintainer="Christian Loos <cloos@netsandbox.de>"

ENV RT_VERSION 4.0.25
ENV RT_SHA 69daa9b9e6c9acb4ca31ec1c3efc8bb4901cc7047eed784f2f91515815fdd4cd

RUN cd /usr/local/src \
  && curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-${RT_VERSION}.tar.gz" -o rt.tar.gz \
  && echo "${RT_SHA}  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && rm rt.tar.gz \
  && cd "rt-${RT_VERSION}" \
  && ./configure \
    --disable-gpg \
    --enable-gd \
    --enable-graphviz \
    --with-db-type=SQLite \
    --with-devel-mode \
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
