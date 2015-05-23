#Docker Container for Drupal#
==================================
A configurable Docker container for Drupal.


This is a highly configurable container for running [Drupal](https://www.drupal.org/). It allows for quick easy setup of new site, as well as loading in an existing site (WIP).

##Usage##
To run with default and minimal settings, it is easiest to run the following:

We will run with an official default MySQL Docker image
```
docker run -P -e MYSQL_ROOT_PASSWORD=development --name mysql-dev -t mysql
```

Now we run and link Drupal with basic settings to the mysql container.
```
docker run -p 8080:80 --name drupal-dev -e MYSQL_USER=root -e MYSQL_PASSWORD=development --link mysql-dev:mysql -t jamesbrink/drupal
```

if you ran this on localhost you should  now be able to go to
http://localhost:8080/

You can login with the default username/password of admin/admin


##Environment Variables##
This is a list of the available environment variables which can be set at runtime using -e KEY=value.
For example, to change the default password you can issue --

###Variables for Drupal###
* `DRUPAL_USER`: The admin username for site. default: `admin`
* `DRUPAL_PASSWORD`: The admin password for the site. default: `admin`
* `DRUPAL_VERSION`: The version of Drupal to download and install. default: `7.37`
* `DRUPAL_SITE_NAME`: The name of the new Drupal site. default: `Site-Install`

###Variables for MySQL###
* `MYSQL_USER`: The MySQL user with privileges to create schema and users. default: `root`
* `MYSQL_PASSWORD`: The MySQL password for user with privileges to create schemas and users. default: `dev`
* `MYSQL_USE_DRUPAL_USER`: The user that Drupal will use when connecting to MySQL(if MYSQL_USE_DRUPAL_USER != "yes"). default: `yes`
* `MYSQL_DRUPAL_USER`:The user that Drupal will use when connecting to MySQL(if MYSQL_USE_DRUPAL_USER != "yes"). default: `drupal`
* `MYSQL_DRUPAL_PASSWORD`: The password for the user that Drupal will use when connecting to MySQL(if MYSQL_USE_DRUPAL_USER != "yes"). default: `drupal`
* `MYSQL_DRUPAL_SCHEMA`: The name of the database/schema to create or use in MySQL. default: `drupal`
* `MYSQL_HOST`: Hostname or IP Address of the host running MySQL. default: `mysql`
* `MYSQL_PORT`: TCP port to use when connecting to MySQL. default: `3306`


