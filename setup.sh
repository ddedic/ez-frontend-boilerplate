#!/bin/bash

mysql_user="mysql"
mysql_password="mysql"
mysql_host="mysql"



read -p "What is the name of the project?: " projectName

echo -n "Do you want do install SCSS Boilerplate (y/n)? "
read installFrontend

echo -n "Do you want do install StyleflashereZPlatformBaseBundle (y/n)? "
read installBaseBundle

# ADD LOCAL DOMAIN
echo "127.0.0.1 $projectName" >> /etc/hosts

# CREATE DB
mysql -u $mysql_user -p$mysql_password -h $mysql_host -e "CREATE DATABASE $projectName;"

# CREATE EZPUBLISH INSTALLTION
cd ../
composer create-project --no-dev --keep-vcs ezsystems/ezplatform $projectName
cd $projectName

# INSTALL BASE BUNDLE
if [ "$installBaseBundle" == "y" ] ;then
    composer require styleflasher/ezplatformbasebundle
fi

# INSTALL SCSS BOILERPLATE
if [ "$installFrontend" == "y" ] ;then
    cd app/Resources
    mkdir public
    cd public
    cd ../../../
    cp ../ez-frontend-boilerplate/src/package.json package.json
    cp ../ez-frontend-boilerplate/src/.eslintrc .eslintrc
    cp ../ez-frontend-boilerplate/src/.htaccess web/.htaccess
    cp ../ez-frontend-boilerplate/src/.sass-lint.yml .sass-lint.yml
    cp ../ez-frontend-boilerplate/src/webpack.config.js webpack.config.js
    cp -r ../ez-frontend-boilerplate/src/js app/Resources/public/js
    cp -r ../ez-frontend-boilerplate/src/scss app/Resources/public/scss
    npm install
fi

export SYMFONY_ENV="prod"
php bin/console ezplatform:install clean
php bin/console assetic:dump
export SYMFONY_ENV="env"

echo "💪  We are done!"
echo "Open http://www.$projectName.ez6 in your Browser"