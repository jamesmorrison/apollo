#!/bin/bash

## Stop interactive output

export DEBIAN_FRONTEND=noninteractive


echo "================================================"
echo "Starting Apollo configuration setup "
echo "================================================"


# Add the PHP repository

echo "Adding the ppa:ondrej/php repository..."

apt install software-properties-common -y > /dev/null 2>&1

add-apt-repository ppa:ondrej/php > /dev/null 2>&1


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

if ! which nginx > /dev/null 2>&1; then

	echo "Installing Nginx..."

	apt-get install nginx -y > /dev/null 2>&1

	sed -i "s/worker_connections 768/worker_connections 1024/" /etc/nginx/nginx.conf
	sed -i "s/# multi_accept on/multi_accept on/" /etc/nginx/nginx.conf
	sed -i "s/keepalive_timeout 65/keepalive_timeout 15/" /etc/nginx/nginx.conf
	sed -i "s/# server_tokens off/server_tokens off; client_max_body_size 64m; fastcgi_buffers 16 16k; fastcgi_buffer_size 32k/" /etc/nginx/nginx.conf

	rm -R /etc/nginx/sites-available/*
	rm -R /etc/nginx/sites-enabled/*

	cp /vagrant/.files/000-default.conf /etc/nginx/sites-enabled/
	cp /vagrant/.files/index.html /projects/sites/000-default/

	service ngxinx restart > /dev/null 2>&1

else

	echo "Nginx is already installed; skipping..."

fi


## Install SSL certificate

# Ensure the folder does not exist..
if [ ! -d "/etc/nginx/ssl" ]; then

	echo "Installing SSL certificate..."

	mkdir /etc/nginx/ssl
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt -subj "/C=GB/ST=London/L=London/O=Apollo/OU=Apollo/CN=*.dev" > /dev/null 2>&1

else

	echo "SSL certificates are already configured; skipping..."

fi

## Install MySQL

if ! which mysql > /dev/null 2>&1; then

	echo "Installing MySQL Server..."

	debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
	debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

	apt-get install mysql-server -y > /dev/null 2>&1

	service mysql restart

else

	echo "MySQL Server is already installed; skipping..."

fi

## Install PHP 7.0

if ! which php7.0 > /dev/null 2>&1; then

	echo "Installing PHP 7.0 and dependencies..."

	apt-get install php7.0-bcmath php7.0-cgi php7.0-cli php7.0-curl php7.0-dev php7.0-fpm php7.0-gd php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-imap php7.0-json php7.0-pspell php7.0-soap php7.0-xml php7.0-xmlrpc php7.0-zip php-imagick php-memcache php-pear -y > /dev/null 2>&1

	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
	sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" /etc/php/7.0/fpm/php.ini
	sed -i "s/post_max_size = 8M/post_max_size = 64M/" /etc/php/7.0/fpm/php.ini

	echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'vagrant@apollo'" > /etc/php/7.0/mods-available/mailcatcher.ini

	service php7.0-fpm restart

else

	echo "PHP 7.0 and dependencies are already installed; skipping..."

fi


## Install PHP 7.1

if ! which php7.1 > /dev/null 2>&1; then

	echo "Installing PHP 7.1 and dependencies..."

	apt-get install php7.1-bcmath php7.1-cgi php7.1-cli php7.1-curl php7.1-dev php7.1-fpm php7.1-gd php7.1-mbstring php7.1-mysql php7.1-imap php7.1-json php7.1-pspell php7.1-soap php7.1-xml php7.1-xmlrpc php7.1-zip php-imagick php-memcache php-pear libargon2-0 libsodium18 libssl1.1 php7.1-common php7.1-opcache php7.1-readline -y > /dev/null 2>&1

	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini
	sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" /etc/php/7.1/fpm/php.ini
	sed -i "s/post_max_size = 8M/post_max_size = 64M/" /etc/php/7.1/fpm/php.ini
	
	echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'vagrant@apollo'" > /etc/php/7.1/mods-available/mailcatcher.ini

	service php7.1-fpm restart

else

	echo "PHP 7.1 and dependencies are already installed; skipping..."

fi


## Install PHP 7.2

if ! which php7.2 > /dev/null 2>&1; then

	echo "Installing PHP 7.2 and dependencies..."

	apt-get install php7.2-bcmath php7.2-cgi php7.2-cli php7.2-curl php7.2-dev php7.2-fpm php7.2-gd php7.2-mbstring php7.2-mysql php7.2-imap php7.2-json php7.2-pspell php7.2-soap php7.2-xml php7.2-xmlrpc php7.2-zip php-imagick php-memcache php-pear libargon2-0 libsodium18 libssl1.1 php7.2-common php7.2-opcache php7.2-readline -y > /dev/null 2>&1

	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini
	sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" /etc/php/7.2/fpm/php.ini
	sed -i "s/post_max_size = 8M/post_max_size = 64M/" /etc/php/7.2/fpm/php.ini

	echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'vagrant@apollo'" > /etc/php/7.2/mods-available/mailcatcher.ini

	service php7.2-fpm restart
	
	# PHP 7.2 became the default as of 06/12/2017; this ensures that the latest update is copied into place if PHP 7.2 is installed - i.e. when a user updates Apollo, they switch to PHP 7.2
	# Note that existing custom configurations will not be touched, PHP 7.0 continues to remain available so there shouldn't be a problem on update
	cp /vagrant/.files/000-default.conf /etc/nginx/sites-enabled/
	cp /vagrant/.files/000-phpmyadmin.conf /etc/nginx/sites-enabled/
	
	service nginx restart

else

	echo "PHP 7.2 and dependencies are already installed; skipping..."

fi



## Install PHP My Admin

if [ ! -d /usr/share/phpmyadmin/ ]; then

	echo "Installing PHP My Admin..."

	apt-get install phpmyadmin -y > /dev/null 2>&1

	cp /vagrant/.files/000-phpmyadmin.conf /etc/nginx/sites-enabled/

	service nginx restart

else

	echo "PHP My Admin is already installed; skipping..."

fi


## Install Mailcatcher

if ! which mailcatcher > /dev/null 2>&1; then

	echo "Installing Mailcatcher... (this takes a while)"

	gem install mailcatcher --no-rdoc --no-ri > /dev/null 2>&1

	echo "@reboot root $(which mailcatcher) --ip=0.0.0.0" >> /etc/crontab
	update-rc.d cron defaults

	echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'vagrant@apollo'" > /etc/php/7.0/mods-available/mailcatcher.ini
	echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'vagrant@apollo'" > /etc/php/7.1/mods-available/mailcatcher.ini
	echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'vagrant@apollo'" > /etc/php/7.2/mods-available/mailcatcher.ini

	phpenmod mailcatcher

	/usr/bin/env $(which mailcatcher) --ip=0.0.0.0 > /dev/null 2>&1

else

	echo "Mailcatcher is already installed; skipping..."

fi


## Install WP-CLI

if [ ! -f /usr/local/bin/wp ]; then

	echo "Installing WP-CLI..."

	cd /
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null 2>&1
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

else

	echo "WP CLI is already installed; skipping..."

fi


## Install WordPress Template


if [ ! -f /projects/sites/000-template/wp-load.php ]; then

	echo "Installing WordPress Template..."

	cd /projects/sites/000-template
	wp core download --allow-root > /dev/null 2>&1
	cp /vagrant/.files/wp-config.php .

else

	echo "WP Template is already installed; skipping..."

fi


## Cleanup

echo "Cleaning up..."

apt-get autoremove -y > /dev/null 2>&1
apt-get clean > /dev/null 2>&1


## All Done :)

echo "================================================"
echo "Apollo configuration is complete"
echo ""
echo "As a number of packages have been installed it is"
echo "recommended you reload vagrant now"
echo ""
echo "To do this, type 'vagrant reload'"
echo "================================================"
