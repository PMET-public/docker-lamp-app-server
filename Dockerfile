FROM esepublic/baseimage
MAINTAINER Keith Bentrup <kbentrup@ebay.com>

ENV WEB_SERVER_USER=www-data XDEBUG_REMOTE_HOST=127.0.0.1 XDEBUG_REMOTE_PORT=9000

RUN add-apt-repository ppa:ondrej/php5-5.6 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes apache2 \
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
    libxml2-utils && \
  apt-get --purge autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*  

RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer

# remove default sites
# enable ssl, rewrite, redis
# disable xdebug
RUN rm -rf /etc/apache2/sites-available/* /etc/apache2/sites-enabled/* && \
  mkdir -p /var/lock/apache2 \
  /var/run/apache2 \
  /etc/apache2/conf.d && \
  a2enmod ssl \
    rewrite \
    headers && \
  pecl install redis && \
  echo "extension=redis.so" > /etc/php5/mods-available/redis.ini && \
  php5enmod redis  && \
  php5dismod xdebug

# install webgrind for profiling
ADD https://webgrind.googlecode.com/files/webgrind-release-1.0.zip /
RUN unzip /webgrind-release-1.0.zip -d / && \
  chown -R www-data:www-data /webgrind && \
  chmod -R g+w /webgrind
  
COPY apache2.conf envvars /etc/apache2/

COPY apache2.sh /etc/service/apache2/run

COPY xdebug.ini /etc/php5/mods-available/
RUN touch /var/log/xdebug.log && chown "${WEB_SERVER_USER}" /var/log/xdebug.log && \
  /bin/echo -e "xdebug.remote_host=${XDEBUG_REMOTE_HOST}\nxdebug.remote_port=${XDEBUG_REMOTE_PORT}" >> /etc/php5/mods-available/xdebug.ini

EXPOSE 80 443
