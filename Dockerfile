FROM pmetpublic/baseimage:0.9.18
MAINTAINER Keith Bentrup <kbentrup@magento.com>

ENV WEB_SERVER_USER=www-data

RUN add-apt-repository ppa:ondrej/php && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
    redis-tools \
    git \
    npm \
    ruby \
    apache2 \
    libapache2-mod-php7.0 \
    php7.0 \
    php7.0-common \
    php7.0-gd \
    php7.0-mysql \
    php7.0-mcrypt \
    php7.0-curl \
    php7.0-intl \
    php7.0-xsl \
    php7.0-mbstring \
    php7.0-zip \
    php7.0-bcmath \
    php7.0-xdebug \
    unzip \
    mysql-client \
    libxml2-utils \
    default-jre \
    rdfind \
    symlinks \
    ssmtp \
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
  (find /usr/lib/php -name "xdebug.so" | sort | tail -1 | sed 's/^/zend_extension=/' | tee /etc/php/7.0/cli/conf.d/xdebug-path.ini > /etc/php/7.0/apache2/conf.d/xdebug-path.ini) && \
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
