#!/bin/bash

## Stop interactive output

export DEBIAN_FRONTEND=noninteractive


echo "================================================"
echo "Starting Apollo configuration setup "
echo "================================================"


## Update all the things

echo "Updating system services... (this takes a while)"

apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1

echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


## Install Nginx

echo "Installing Nginx..."

apt-get install nginx -y > /dev/null 2>&1

sed -i "s/worker_connections 768/worker_connections 1024/" /etc/nginx/nginx.conf
sed -i "s/# multi_accept on/multi_accept on/" /etc/nginx/nginx.conf
sed -i "s/keepalive_timeout 65/keepalive_timeout 15/" /etc/nginx/nginx.conf
sed -i "s/# server_tokens off/server_tokens off; client_max_body_size 64m/" /etc/nginx/nginx.conf

rm -R /etc/nginx/sites-available/*
rm -R /etc/nginx/sites-enabled/*
cp /vagrant/.config/nginx-default.conf /etc/nginx/sites-enabled/
cp /vagrant/.config/index.html /projects/sites/000-default/
service ngxinx restart > /dev/null 2>&1

## Install MySQL

echo "Installing MySQL Server..."

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

apt-get install mysql-server -y > /dev/null 2>&1


## Install PHP 7

echo "Installing PHP 7 and dependencies..."

apt-get install php7.0-cli php7.0-dev php7.0-fpm php7.0-cgi php7.0-mysql php7.0-xmlrpc php7.0-curl php7.0-gd php7.0-imap php7.0-pspell php7.0-xml -y > /dev/null 2>&1

sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" /etc/php/7.0/fpm/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 64M/" /etc/php/7.0/fpm/php.ini


## Install WP-CLI

echo "Installing WP-CLI..."

cd /
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null 2>&1
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp


## Install WordPress

echo "Installing WordPress..."

cd /projects/sites/000-template
wp core download --allow-root > /dev/null 2>&1
cp /vagrant/.config/wp-config.php .

mysql -uroot -proot -e "CREATE DATABASE wp_template" > /dev/null 2>&1 | grep -v "Warning: Using a password"

rm wp-config-sample.php
rm wp-content/plugins/hello.php
rm -R wp-content/plugins/akismet

## All Done :)

echo "================================================"
echo "Apollo configuration is complete"
echo "================================================"
