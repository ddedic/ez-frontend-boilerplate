#!/bin/bash

read -p "What is the name of the project?: " projectName

echo -n "Do you want do install SCSS Boilerplate (y/n)? "
read installFrontend

echo -n "Do you want do install StyleflashereZPlatformBaseBundle (y/n)? "
read installBaseBundle


# CREATE DB
mysql -u homestead -psecret -h localhost  -e "CREATE DATABASE $projectName;"


# CREATE EZPUBLISH INSTALLTION
cd ../
composer create-project --no-dev --keep-vcs ezsystems/ezplatform $projectName
cd $projectName

export SYMFONY_ENV="prod"
php bin/console ezplatform:install clean
php bin/console assetic:dump


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
    cp ../setup/src/package.json package.json
    cp ../setup/src/.eslintrc .eslintrc
    cp ../setup/src/.htaccess web/.htaccess
    cp ../setup/src/.sass-lint.yml .sass-lint.yml
    cp ../setup/src/webpack.config.js webpack.config.js
    cp -r ../setup/src/js app/Resources/public/js
    cp -r ../setup/src/scss app/Resources/public/scss
    npm install
fi

open "http://" $projectName ".local"