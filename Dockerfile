FROM esepublic/baseimage
MAINTAINER Keith Bentrup <kbentrup@ebay.com>

ENV WEB_SERVER_USER=www-data

RUN echo "deb http://repos.zend.com/zend-server/early-access/php7/repos ubuntu/" >> /etc/apt/sources.list

RUN add-apt-repository ppa:ondrej/php5-5.6 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes apache2 \
    libapache2-mod-php5 \
    redis-tools \
    git \
    npm \
    ruby \
    php7-beta1 \
    php5-cli \
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

COPY php.ini /usr/local/php7/etc/
COPY php7.conf /etc/apache2/mods-available/

RUN mkdir -p /etc/apache2/conf.d/ && \
  touch /etc/apache2/conf.d/default.conf && \
  cp /usr/local/php7/libphp7.so /usr/lib/apache2/modules/ && \
  cp /usr/local/php7/php7.load /etc/apache2/mods-available/ && \
  a2dismod php5 && \
  a2enmod php7 \
    headers \
    ssl \
    rewrite \
    expires && \
  php5enmod mcrypt

# RUN ln -sf /usr/local/php7/bin/php /usr/bin/php && \ 
# can make php7 the default cmd line when the php5 extensions are available or linked to it to prevent errors like
# "The requested PHP extension ext-xsl * is missing from your system. Install or enable PHP's xsl extension"

RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer

# remove default sites
# enable ssl, rewrite
RUN rm -rf /etc/apache2/sites-available/* /etc/apache2/sites-enabled/* && \
  mkdir -p /var/lock/apache2 /var/run/apache2 && \
  a2enmod ssl rewrite 
  
COPY apache2.conf envvars /etc/apache2/
COPY apache2.sh /etc/service/apache2/run

EXPOSE 80 443
