FROM netsandbox/request-tracker-base

MAINTAINER Christian Loos <cloos@netsandbox.de>

ENV RT_VERSION 4.0.24
ENV RT_SHA1 0588b678cc1f13ae1504e9fffede1b8485d172f7

RUN cd /usr/local/src \
  && curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-${RT_VERSION}.tar.gz" -o rt.tar.gz \
  && echo "${RT_SHA1}  rt.tar.gz" | shasum -c \
  && tar -xvzf rt.tar.gz \
  && rm rt.tar.gz \
  && cd "rt-${RT_VERSION}" \
  && ./configure \
    --disable-gpg \
    --disable-smime \
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
RUN chown root:www-data /opt/rt4/etc/RT_SiteConfig.pm \
  && chmod 0640 /opt/rt4/etc/RT_SiteConfig.pm

VOLUME /opt/rt4

EXPOSE 80
CMD ["/usr/sbin/apache2","-DFOREGROUND"]
