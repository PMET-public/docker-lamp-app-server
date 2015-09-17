FROM esepublic/baseimage
MAINTAINER Keith Bentrup <kbentrup@ebay.com>

RUN add-apt-repository ppa:ondrej/php5-5.6 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes apache2 \
    libapache2-mod-php5 \
    php5-cli \
    php5-curl \
    php5-gd \
    php5-mcrypt \
    php-pear \
    php5-dev \
    php5-mysql \
    php5-intl \
    php5-xsl \
    mysql-client && \
  apt-get --purge autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# install mod_pagespeed
RUN cd /tmp && \
  curl -O https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-beta_current_amd64.deb && \
  dpkg -i /tmp/mod-pagespeed-beta_current_amd64.deb && \
  apt-get -f install && \
  rm -rf /tmp/*

# remove default sites, enable ssl, rewrite
RUN rm -rf /etc/apache2/sites-available/* /etc/apache2/sites-enabled/* && \
  mkdir -p /var/lock/apache2 /var/run/apache2 && \
  a2enmod ssl && \
  ln -sf /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
  
# runit apache2
RUN mkdir -p /etc/service/apache2 && \
  ln -sf /scripts/apache2.sh /etc/service/apache2/run

EXPOSE 80 443
