<?php

// Database

define( 'DB_NAME',      '' ); // UPDATE THIS TO THE DB NAME
define( 'DB_USER',      'root' );
define( 'DB_PASSWORD',  'root' );
define( 'DB_HOST',      'localhost' );
define( 'DB_CHARSET',   'utf8' );
define( 'DB_COLLATE',   '' );
$table_prefix  = 'wp_';


// Salts

define('AUTH_KEY',         '<,;ce&$KszW+>g2YE-t!D1vhGA7wF|3Kf6xH[ Ct<6oZaZ2c@ml:6C@xo.lkC*R0');
define('SECURE_AUTH_KEY',  'rmj[co9ruoNol!-@$Y LN_A]i9D?=HYkr:R,&-vF.8F6W8(A?`&Kv3P|+;bBl/5f');
define('LOGGED_IN_KEY',    'hJ8]W-gC}0np/|GLP)GM{knv@Aft+a6pA9Ivg,*<5M{;W`D43L.~},(#P|i|dtL|');
define('NONCE_KEY',        'R>$l239mO-cy/$yx?rA/O>m1~Zg};8cwW=o0{h6iE3wi3|OmIRU[WHL4meI)MjcE');
define('AUTH_SALT',        'GA#Jt ^nc/lo#nQyhk[,@+@+6Q9!jQw~v{}M~F4K_e|}vN48[^zhGpQ.*f]8-[,$');
define('SECURE_AUTH_SALT', 'Lnmyd61SekoB%-eVt6UYLSOwd#Q2)`$7w]-r3,XMl?a!afQV7@`mH QY7CFk{9xL');
define('LOGGED_IN_SALT',   ']$2RbMiT:t>lITjxH8WAS(IMZTEmVhy&>9/#^i<0`#/h8[? p_YPi8-)nQC&,~WD');
define('NONCE_SALT',       '+cXDS%Z$GH)K,$ JvgHD%bXO`02{.56k[kKgt{U@]0P+nyQ)Pq)h=Tf6LY1_^4k2');


// Multisite

# define( 'WP_ALLOW_MULTISITE',   true );
# define( 'MULTISITE',            true );
# define( 'SUBDOMAIN_INSTALL',    true);
# define( 'DOMAIN_CURRENT_SITE',  '' ); // UPDATE THIS TO THE MAIN SITE URL
# define( 'PATH_CURRENT_SITE',    '/');
# define( 'SITE_ID_CURRENT_SITE', 1);
# define( 'BLOG_ID_CURRENT_SITE', 1);
# define( 'SUNRISE',              'on' );
# define( 'NOBLOGREDIRECT',       '' );


// Debugging

define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', isset( $_GET[ 'debug' ] ) ? true : false );


// Disable Auto Updates

define( 'WP_AUTO_UPDATE_CORE', false );

// Security Enhancements

define( 'FORCE_SSL_ADMIN',      true );


// Compression

define( 'COMPRESS_CSS',         true );
define( 'COMPRESS_SCRIPTS',     true );
define( 'ENFORCE_GZIP',         true );

// Allow Updates

define( 'FS_METHOD', 'direct' );

// Local Dev

define( 'LOCAL_DEV', true );
define( 'WP_LOCAL_DEV', true );


// Load WP

if ( ! defined('ABSPATH') ) define( 'ABSPATH', dirname( __FILE__ ) . '/' );
require_once( ABSPATH . 'wp-settings.php' );
