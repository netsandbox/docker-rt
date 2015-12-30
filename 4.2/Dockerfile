FROM netsandbox/request-tracker-base

MAINTAINER Christian Loos <cloos@netsandbox.de>

ENV RT_VERSION 4.2.12
ENV RT_SHA1 ddbf70752c2b96354caf7687534addf075859d4d

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
  && make install \
  && make initdb

COPY apache.rt.conf /etc/apache2/sites-available/rt.conf
RUN a2dissite 000-default.conf && a2ensite rt.conf

RUN chown -R www-data:www-data /opt/rt4/var/

VOLUME /opt/rt4

EXPOSE 80
CMD ["/usr/sbin/apache2","-DFOREGROUND"]
