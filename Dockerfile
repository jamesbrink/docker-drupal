# Drupal
#
# VERSION      1.0.0

FROM ubuntu:vivid
MAINTAINER James Brink, brink.james@gmail.com

# Setup needed dependencies
RUN apt-get update && apt-get install -y \
  apache2 \
  curl \
  git \
  mysql-client \
  php5 \
  php5-apcu \
  php5-cli \
  php5-cli \
  php5-curl \
  php5-gd \
  php5-imagick \
  php5-mysql \
  php5-pecl-http \
  sendmail \
  && rm -rf /var/lib/apt/lists/*

# Prep apache for Drupal
RUN rm -rf /var/www/html/* \
  && a2enmod rewrite && a2enmod authz_groupfile \
  && sed -i "s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf \
  && mkdir -p /local/opt/docker-assets \
  # Install composer
  && curl https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && composer global require drush/drush:7.*

ENV PATH /local/opt/docker-assets/bin:/root/.composer/vendor/bin:$PATH

# Variables for Drupal
ENV DRUPAL_USER admin
ENV DRUPAL_PASSWORD admin
ENV DRUPAL_VERSION 7.37
ENV DRUPAL_SITE_NAME "Site-Install"

# Variables for MySQL
ENV MYSQL_USER root
ENV MYSQL_PASSWORD dev
ENV MYSQL_USE_DRUPAL_USER yes
ENV MYSQL_DRUPAL_USER drupal
ENV MYSQL_DRUPAL_PASSWORD drupal
ENV MYSQL_DRUPAL_SCHEMA drupal
ENV MYSQL_HOST mysql
ENV MYSQL_PORT 3306


EXPOSE 80
EXPOSE 443

# Copy any docker assets into container
COPY ./assets /local/opt/docker-assets/
RUN chmod -R 775 /local/opt/docker-assets

CMD ["/local/opt/docker-assets/bin/start_drupal.sh"]
