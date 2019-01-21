FROM ubuntu:18.04
MAINTAINER Myself <me@mydomain.com>

# Update Ubuntu and package sources
RUN apt-get update && \ 
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common && \ 
    add-apt-repository ppa:ondrej/php

# Install apache, PHP, and supplimentary programs
RUN apt-get update && \ 
    DEBIAN_FRONTEND=noninteractive apt-get -y install \ 
    php7.3 libapache2-mod-php7.3 php7.3-cli php7.3-mysql php7.3-imagick php7.3-recode php7.3-tidy php7.3-xmlrpc \ 
	php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-xml \ 
	apache2 curl nano

# Set PHP version (could switch to other 7.* using this, 7.3 will be default)
RUN update-alternatives --set php /usr/bin/php7.3

# Enable apache mods
RUN a2enmod php7.3
RUN a2enmod rewrite

# Update the PHP.ini file (for production, should disable displaying errors)
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.3/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT/" /etc/php/7.3/apache2/php.ini
RUN sed -i "s/display_errors = .*$/display_errors = On/" /etc/php/7.3/apache2/php.ini
RUN sed -i "s/display_startup_errors = .*$/display_startup_errors = On/" /etc/php/7.3/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache
EXPOSE 80

# Copy this repo into place
ADD www /var/www/site

# Update the default apache site with the config we created
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default start up apache in the foreground, override with /bin/bash for interative
CMD /usr/sbin/apache2ctl -D FOREGROUND