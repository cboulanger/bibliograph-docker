# Bibliograph - Online Bibliographic Data Manager
# Build the latest version published on http://souratceforge.net/projects/bibliograph/files/
# todo: use MarvAmBass/docker-apache2-ssl-secure or similar image as base

FROM ubuntu:14:04
MAINTAINER Christian Boulanger <info@bibliograph.org>

ENV DEBIAN_FRONTEND noninteractive

# Packages
RUN apt-get update && apt-get install -y \
  supervisor apache2 libapache2-mod-php5 php5-cli \
  mysql-server php5-mysql \
  bibutils \
  php5-dev php-pear \
  wget \
  php5-xsl php5-intl\
  yaz libyaz4-dev \
  zip

# Install php-yaz
RUN pecl install yaz && \
  pear install Structures_LinkedList-0.2.2 && \
  pear install File_MARC && \
  echo "extension=yaz.so" >> /etc/php5/apache2/php.ini && \
  echo "extension=yaz.so" >> /etc/php5/cli/php.ini

# enable SSL, not working
RUN /bin/ln -sf ../sites-available/default-ssl /etc/apache2/sites-enabled/001-default-ssl && \
  a2enmod ssl && a2enmod socache_shmcb
  
# Environment variables for the setup
ENV BIB_VAR_DIR /var/lib/bibliograph
ENV BIB_CONF_DIR /var/www/html/bibliograph/services/config/
ENV BIB_USE_HOST_MYSQL no
ENV BIB_MYSQL_USER root
ENV BIB_MYSQL_PASSWORD secret

# download and install latest version from Sourceforge
# to get around the docker build cache, modify the last echo statement

RUN rm -rf /var/www/html/* && \
  wget -qO- -O tmp.zip http://sourceforge.net/projects/bibliograph/files/latest/download && \
  unzip -qq tmp.zip -d /var/www/html && rm tmp.zip && \
  echo "<?php header('location: /bibliograph/build');" > /var/www/html/index.php && \
  mkdir -p $BIB_VAR_DIR && chmod 0777 $BIB_VAR_DIR && \
  echo "Installed bibliograph ..."
  
# add configuration files
COPY bibliograph.ini.php $BIB_CONF_DIR/bibliograph.ini.php
COPY server.conf.php $BIB_CONF_DIR/server.conf.php
COPY plugins.txt /var/www/html/bibliograph/plugins.txt

# supervisor files
COPY supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
COPY supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# add mysqld configuration
COPY my.cnf /etc/mysql/conf.d/my.cnf

# Start command
COPY run.sh /run.sh
COPY start-apache2.sh /start-apache2.sh
COPY start-mysqld.sh /start-mysqld.sh

# Expose ports
EXPOSE 80 443

# Run
RUN chmod 755 /*.sh
CMD ["/run.sh"]
