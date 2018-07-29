#!/bin/bash
mysql_user="mysql"
mysql_password="mysql"
mysql_host="mysql"

read -p "What is the name of the project?: " projectName

export SYMFONY_ENV="prod"

# CREATE EZPUBLISH INSTALLTION
cd ../
php -d memory_limit=-1 -d memory_limit=-1 /usr/local/bin/composer create-project --no-dev --keep-vcs ezsystems/ezplatform $projectName
cd $projectName

# INSTALL EZ
chmod +x bin/console

php -d memory_limit=-1 bin/console ezplatform:install clean

export SYMFONY_ENV="dev"
php -d memory_limit=-1 /usr/local/bin/composer install
php -d memory_limit=-1 bin/console assetic:dump
php -d memory_limit=-1 bin/console cache:clear

# Base Config
cp -r ../ez-frontend-boilerplate/src/assets app/Resources/
cp ../ez-frontend-boilerplate/src/package.json package.json
cp ../ez-frontend-boilerplate/src/.eslintrc .eslintrc
cp ../ez-frontend-boilerplate/src/.htaccess web/.htaccess
cp ../ez-frontend-boilerplate/src/.sass-lint.yml .sass-lint.yml
cp ../ez-frontend-boilerplate/src/webpack.config.js webpack.config.js

php -d memory_limit=-1 bin/console cache:clear

# Composer Packages
#php -d memory_limit=-1 /usr/local/bin/composer require netgen/information-collection-bundle
#php -d memory_limit=-1 /usr/local/bin/composer require kaliop/ezmigrationbundle
#php -d memory_limit=-1 /usr/local/bin/composer require novactive/ezseobundle
#php -d memory_limit=-1 /usr/local/bin/composer require styleflasher/ezplatformbasebundle

cp ../ez-frontend-boilerplate/src/composer.json composer.json
php -d memory_limit=-1 /usr/local/bin/composer update

cp ../ez-frontend-boilerplate/src/AppKernel.php app/AppKernel.php
cp ../ez-frontend-boilerplate/src/config.yml app/config/config.yml
cp ../ez-frontend-boilerplate/src/view.yml app/config/view.yml

# Create Bundle
php -d memory_limit=-1 bin/console generate:bundle

# Run Migration
#cp ../ez-frontend-boilerplate/src/20180728193452_baseconfig.yml 20180728193452_baseconfig.yml

npm install

echo "💪  We are done!"
echo "Open http://www.$projectName.ez6 in your Browser"