FROM centos:7

RUN yum -y update && \
  yum -y install \
  wget \
  vim \
  git \
  net-tools \
  yum-utils \
  initscripts \
  epel-release

RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php74 && \
    yum -y update

RUN yum install -y \
    php74-php-pear \
    php74-php-pecl-mysql \
    php74-php-xmlrpc \
    php74-php-xml \
    php74-php-mcrypt \
    php74-php-pecl-igbinary \
    php74-php-cli \
    php74-php-fpm \
    php74-php-pgsql \
    php74-php-pecl-memcached \
    php74-php-mbstring \
    php74-php-bcmath \
    php74-php-opcache \
    php74-php-gd \
    php74-php-process \
    php74-php-pdo \
    php74-php-pecl-redis \
    php74-php-pecl-mongodb \
    php74-php-imap \
    php74-php-tidy \
    php74-php-pecl-imagick \
    php74-php-cli \
    php74-php-phpiredis 

RUN ln -s /usr/bin/php74 /usr/bin/php && \
    chmod +x /usr/bin/php

RUN yum -y install supervisor

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer 

RUN sed -i "s,listen = 127.0.0.1:9000,listen = 9000,g" /etc/opt/remi/php74/php-fpm.d/www.conf && \
    sed -i "s,listen.allowed_clients = 127.0.0.1,;listen.allowed_clients = 127.0.0.1,g" /etc/opt/remi/php74/php-fpm.d/www.conf && \
    sed -i "s,daemonize = yes,daemonize = no,g" /etc/opt/remi/php74/php-fpm.conf

EXPOSE 9000

RUN yum clean all

CMD ["/usr/bin/supervisord"]

