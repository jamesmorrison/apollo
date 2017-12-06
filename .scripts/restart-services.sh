#!/bin/bash
set -e

# Restart MySQL
service mysql restart

# Restart Nginx
service nginx restart

# Conditionally restart PHP 7.0
if which php7.0 > /dev/null 2>&1; then
	service php7.0-fpm restart
fi

# Conditionally restart PHP 7.1
if which php7.1 > /dev/null 2>&1; then
	service php7.1-fpm restart
fi

# Conditionally restart PHP 7.2
if which php7.2 > /dev/null 2>&1; then
	service php7.2-fpm restart
fi