# Bibliograph - Online Bibliographic Data Manager
# Build the latest version published on http://souratceforge.net/projects/bibliograph/files/

FROM ubuntu:latest
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

# enable SSL
RUN /bin/ln -sf ../sites-available/default-ssl /etc/apache2/sites-enabled/001-default-ssl && \
  a2enmod ssl && a2enmod socache_shmcb

# download and install latest version from Sourceforge
# to get around the docker build cache, modify the last echo statement
RUN rm -rf /var/www/html/* && \
  wget -qO- -O tmp.zip http://sourceforge.net/projects/bibliograph/files/latest/download \
  && unzip -qq tmp.zip -d /var/www/html && rm tmp.zip && \
  echo "<?php header('location: /bibliograph/build');" > /var/www/html/index.php && \
  echo "Installed bibliograph ..."
  
# add configuration files
ENV BIB_CONF /var/www/html/bibliograph/services/config/
ADD bibliograph.ini.php $BIB_CONF/bibliograph.ini.php
ADD server.conf.php $BIB_CONF/server.conf.php
ADD plugins.txt /var/www/html/bibliograph/plugins.txt

# supervisor files
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# mount volumes for debugging
VOLUME /var/log/apache2
VOLUME /tmp

# add mysqld configuration
ADD my.cnf /etc/mysql/conf.d/my.cnf

# Expose ports
EXPOSE 80 443

# Start command
ADD run.sh /run.sh
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
RUN chmod 755 /*.sh
CMD ["/run.sh"]