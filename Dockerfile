FROM esepublic/baseimage
MAINTAINER Keith Bentrup <kbentrup@ebay.com>

ENV WEB_SERVER_USER=www-data

RUN add-apt-repository ppa:ondrej/php-7.0 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
    redis-tools \
    git \
    npm \
    ruby \
    apache2 \
    libapache2-mod-php7.0 \
    php7.0  \
    php7.0-common \
    php7.0-gd \
    php7.0-mysql \
    php7.0-mcrypt \
    php7.0-curl \
    php7.0-intl \
    php7.0-xsl \
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
  a2enmod headers \
    ssl \
    rewrite \
    expires

# RUN ln -sf /usr/local/php7/bin/php /usr/bin/php && \ 
# can make php7 the default cmd line when the php5 extensions are available or linked to it to prevent errors like
# "The requested PHP extension ext-xsl * is missing from your system. Install or enable PHP's xsl extension"

RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer

# remove default sites
RUN rm -rf /etc/apache2/sites-available/* /etc/apache2/sites-enabled/* && \
  mkdir -p /var/lock/apache2 /var/run/apache2
  
COPY apache2.conf envvars /etc/apache2/
COPY apache2.sh /etc/service/apache2/run

EXPOSE 80 443
