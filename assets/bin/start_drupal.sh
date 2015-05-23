#!/bin/bash

# TODO secure % wildcard to docker host if possible
SQL_WITH_USER="
CREATE USER '${MYSQL_DRUPAL_USER}' IDENTIFIED BY '${MYSQL_DRUPAL_PASSWORD}';
CREATE DATABASE ${MYSQL_DRUPAL_SCHEMA};
GRANT ALL PRIVILEGES ON ${MYSQL_DRUPAL_SCHEMA}.* TO '${MYSQL_DRUPAL_USER}'@'%';
FLUSH PRIVILEGES;
"

# First time setup
if [[ ! -a /setup-completed && $((`ls -alrt /var/www/html/|wc -l`-3)) == 0 ]]; then
  echo "Running first time setup."
  # Make sure MySQL is up before we try to do install (useful for docker-compose)
  /local/opt/docker-assets/bin/wait_for_mysql.sh
  drush -y dl drupal-$DRUPAL_VERSION --drupal-project-rename=/var/www/html
  cd /var/www/html/

  if [[ "$MYSQL_USE_DRUPAL_USER" == "yes" ]]; then
    mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD -e "${SQL_WITH_USER}"
    drush -y site-install standard --site-name="${DRUPAL_SITE_NAME}" --account-name="${DRUPAL_USER}" --account-pass="${DRUPAL_PASSWORD}" --db-url=mysql://$MYSQL_DRUPAL_USER:$MYSQL_DRUPAL_PASSWORD@$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DRUPAL_SCHEMA 
  else
    mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE ${MYSQL_DRUPAL_SCHEMA};"
    drush -y site-install standard --site-name="${DRUPAL_SITE_NAME}" --account-name="${DRUPAL_USER}" --account-pass="${DRUPAL_PASSWORD}" --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DRUPAL_SCHEMA 
  fi

  # Commented out the following, as it seems bad practice to install
  # Mulltiple durpal sites into same database
  # See https://github.com/drush-ops/drush/issues/134
  # --db-prefix=`echo $MYSQL_TABLE_PREFIX|sed "s/\W/_/g"`

  # Ensure we have proper file permissions
  chown -R www-data:www-data /var/www
  chmod -R 775 /var/www/html/sites/default/files
  touch /setup-completed
fi

# Start apache in foreground
# TODO bring all logs to foreground
rm -f /var/run/apache2/apache2.pid
apachectl -e info -DFOREGROUND
