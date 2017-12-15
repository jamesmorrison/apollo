#!/bin/bash
set -e

ls -d /vagrant/sites/* | while read d
do

	dir=$(sed "s:/vagrant/sites/::g" <<<"$d")

	if [[ "$dir" == *.dev ]]
	then
		echo "Setting up $dir.."

		cd /vagrant/.ssl/

		openssl genrsa -out $dir.key 2048 > /dev/null 2>&1
		openssl req -new -key $dir.key -out $dir.csr \
		-subj /C=XX/ST=Apollo/L=Apollo/O=Apollo/OU=Apollo/CN=$dir > /dev/null 2>&1


		echo "authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names 

[alt_names]
DNS.1 = $dir" > $dir.ext

		openssl x509 -req -in $dir.csr -CA 000-root.pem -CAkey 000-root.key -CAcreateserial \
		-out $dir.crt -days 18250 -sha256 -extfile $dir.ext > /dev/null 2>&1

		echo "server {
    
	server_name $dir;
	listen 80;
	listen 443 ssl;
	
	ssl_certificate      /vagrant/.ssl/$dir.crt;
	ssl_certificate_key  /vagrant/.ssl/$dir.key;

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers   on;
	ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;

	ssl_session_cache shared:SSL:20m;
	ssl_session_timeout 180m;

	set \$root \$host;

	# For subdomains we want the document root to be the root domain only (e.g. 'sub.site.dev' rewrites to 'site.dev')
	# This is for subdomain multisite
	if ( \$host ~* \"(.+)\.((.+)\.([a-z]+|co\.uk))$\" ) {
		set \$root \$2;
	}

	# If the requested domain doesn't exist (the corresponding folder isn't present), rewrite $root to the default folder
	if ( !-d /projects/sites/$root ) {
		set \$root '000-default';
	}

	## Common Nginx config for all sites
	root /projects/sites/\$root;

	index index.php index.html;

	client_max_body_size 64M;

	# Rewrite for WordPress in a sub-folder
	if ( -d /projects/sites/\$root/wordpress ) {
		rewrite ^(/wp-(admin|includes)/(.*))$ /wordpress$1 last;
		rewrite ^(/wp-[^/]*\.php)$ /wordpress$1 last;
	}

	# Rewrite for multisite / sub-directory e.g. site.dev/sub-site/
	# If the file does not exist for wp-admin/* or wp-*.php, try looking in the parent directory
	if ( !-e \$request_filename ) {
		rewrite /wp-admin$ \$scheme://\$host\$uri/ permanent;
		rewrite ^(/[^/]+)?(/wp-.*) \$2 last;
		rewrite ^(/[^/]+)?(/.*\.php) \$2 last;
	}

	# WordPress multisite files handler (legacy)
	location ~ ^(/[^/]+/)?files/(.+) {
		try_files \$uri /wp-includes/ms-files.php?file=\$2 ;
		access_log off; log_not_found off; expires max;
	}	

	# Block all web requests to hidden directories
	location ~ /\. {
		deny all;
	}

	# Block access to build scripts.
	location ~* /(Gruntfile\.js|package\.json|node_modules) {
		deny all;
	}

	# Try file, file/ then fall back to index
	location / {
		
		# Identify the Vagrant box
		add_header X-Vagrant \$hostname;
		
		# Disable caching on all pages / assets
		add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
		expires off;
		
		try_files \$uri \$uri/ /index.php\$is_args\$args;
	}

	# Pass PHP scripts to PHP FPM
	location ~ \.php$ {

		# Identify the Vagrant box
		add_header X-Vagrant \$hostname;

		# Disable caching on all pages / assets
		add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
		expires off;

		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		include snippets/fastcgi-php.conf;

		# Multiple versions of PHP are installed; ensure that only one of these blocks is active..

		#fastcgi_pass unix:/run/php/php7.0-fpm.sock;
		#fastcgi_pass unix:/run/php/php7.1-fpm.sock;
		fastcgi_pass unix:/run/php/php7.2-fpm.sock;
	}

}" > /etc/nginx/sites-enabled/$dir.conf

	sudo service nginx restart > /dev/null 2>&1

	fi

done
