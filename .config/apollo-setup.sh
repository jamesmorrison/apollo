#!/bin/bash

## Stop interactive output

export DEBIAN_FRONTEND=noninteractive


echo "================================================"
echo "Starting Apollo configuration setup "
echo "================================================"


## Update all the things

echo "Updating system services... (this takes a while, might be a good time to put the kettle on)"

apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1


## Tweaking the vagrant user permissions

echo "Tweaking the vagrant user permissions..."

usermod -a -G vagrant www-data > /dev/null 2>&1
echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


## Install Common Components

echo "Installing Common Components..."

apt-get install build-essential colordiff curl dos2unix imagemagick gettext git libsqlite3-dev mailutils ngrep ntp postfix ruby-dev unzip zip -y > /dev/null 2>&1

sed -i "s/inet_interfaces = all/inet_interfaces = loopback-only/" /etc/postfix/main.cf
sed -i "s/inet_protocols = all/inet_protocols = ipv4/" /etc/postfix/main.cf

service postfix restart


## Install Nginx

echo "Installing Nginx..."

apt-get install nginx -y > /dev/null 2>&1

sed -i "s/worker_connections 768/worker_connections 1024/" /etc/nginx/nginx.conf
sed -i "s/# multi_accept on/multi_accept on/" /etc/nginx/nginx.conf
sed -i "s/keepalive_timeout 65/keepalive_timeout 15/" /etc/nginx/nginx.conf
sed -i "s/# server_tokens off/server_tokens off; client_max_body_size 64m; fastcgi_buffers 16 16k; fastcgi_buffer_size 32k/" /etc/nginx/nginx.conf

rm -R /etc/nginx/sites-available/*
rm -R /etc/nginx/sites-enabled/*
cp /vagrant/.config/nginx-default.conf /etc/nginx/sites-enabled/
cp /vagrant/.config/nginx-default-ssl.conf /etc/nginx/sites-enabled/
cp /vagrant/.config/index.html /projects/sites/000-default/
service ngxinx restart > /dev/null 2>&1



## Install SSL certificate

echo "Installing SSL certificate..."

mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt -subj "/C=GB/ST=London/L=London/O=Apollo/OU=Apollo/CN=*.dev" > /dev/null 2>&1


## Install MySQL

echo "Installing MySQL Server..."

debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

apt-get install mysql-server -y > /dev/null 2>&1


## Install PHP 7

echo "Installing PHP 7 and dependencies..."

apt-get install php7.0-bcmath php7.0-cgi php7.0-cli php7.0-curl php7.0-dev php7.0-fpm php7.0-gd php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-imap php7.0-json php7.0-pspell php7.0-soap php7.0-xml php7.0-xmlrpc php7.0-zip php-imagick php-memcache php-pear -y > /dev/null 2>&1

sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" /etc/php/7.0/fpm/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 64M/" /etc/php/7.0/fpm/php.ini


## Install Mailcatcher

echo "Installing Mailcatcher... (this takes a while)"

gem install mailcatcher --no-rdoc --no-ri > /dev/null 2>&1

echo "@reboot root $(which mailcatcher) --ip=0.0.0.0" >> /etc/crontab
update-rc.d cron defaults

echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'www-data@localhost'" >> /etc/php/7.0/mods-available/mailcatcher.ini

phpenmod mailcatcher

/usr/bin/env $(which mailcatcher) --ip=0.0.0.0 > /dev/null 2>&1


## Install WP-CLI

echo "Installing WP-CLI..."

cd /
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null 2>&1
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp


## Install WordPress Template

echo "Installing WordPress Template..."

cd /projects/sites/000-template
wp core download --allow-root > /dev/null 2>&1
cp /vagrant/.config/wp-config.php .


## Cleanup

echo "Cleaning up..."

apt-get autoremove -y > /dev/null 2>&1
apt-get clean > /dev/null 2>&1


## All Done :)

echo "================================================"
echo "Apollo configuration is complete"
echo "================================================"
