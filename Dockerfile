FROM esepublic/baseimage:0.9.18
MAINTAINER Keith Bentrup <kbentrup@magento.com>

ENV WEB_SERVER_USER=www-data

RUN add-apt-repository ppa:ondrej/php5-5.6 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
    apache2 \
    libapache2-mod-php5 \
    redis-tools \
    git \
    npm \
    ruby \
    php5-cli \
    php5-xdebug \
    php5-curl \
    php5-gd \
    php5-mcrypt \
    php-pear \
    php5-dev \
    php5-mysql \
    php5-intl \
    php5-xsl \
    unzip \
    mysql-client \
    libxml2-utils \
    wget && \
  apt-get --purge autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# remove default sites and ensure dirs exist
RUN mkdir -p /etc/apache2/conf.d/ \
  /var/lock/apache2 \
  /var/run/apache2 && \
  rm -rf /etc/apache2/sites-available/* \
  /etc/apache2/sites-enabled/* \
  touch /etc/apache2/conf.d/default.conf && \
  a2enmod headers \
    ssl \
    rewrite \
    expires && \
  phpdismod xdebug && \
  phpenmod opcache

# add yui compress for css min and closure compiler for js
ADD https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar /yuicompressor.jar
RUN wget http://dl.google.com/closure-compiler/compiler-20151216.tar.gz -O - | tar -xz compiler.jar


# add composer
RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer
  
# prevent extraneous logging from cron
RUN sed -i.bak 's/f_syslog3 { not facility(auth/f_syslog3 { not facility(cron, auth/' /etc/syslog-ng/syslog-ng.conf

COPY apache2.conf envvars /etc/apache2/
COPY apache2.sh /etc/service/apache2/run

EXPOSE 80 443
