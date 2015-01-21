# Puppet configuration
include git

Package {
    # Fix for deprecation notice with Yum
    # (see https://inuits.eu/blog/puppet-361-depreciation-warning)
    allow_virtual => true,
}

$php_application_service = 'php-fpm'
$php_modules = ['opcache', 'pdo', 'pgsql', 'mbstring', 'mcrypt', 'bcmath', 'gmp', 'gd', 'openssl']

# PHP install configuration
class { 'php':
    package             => 'php-fpm',

    # Re-enable once https://github.com/example42/puppet-php/pull/81 gets merged...
    #install_options     => [{'--enablerepo' => 'remi-php55'}],

    service             => $php_application_service,
    service_autorestart => true,
}

# PHP modules
php::module { $php_modules: }

# PHP-FPM service
service { $php_application_service:
    ensure => running,
}

# Nginx
$nginx_app_directory = '/vagrant/app'

class { 'nginx':
    log_format => 
    [
        main => '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"'
    ],
    server_tokens => 'off',
    client_max_body_size => '5M',
    sendfile => 'on',
    keepalive_timeout => 65
}

# Ensure that a folder for the app exists
file { [$nginx_app_directory]:
    ensure => "directory"
}

# Nginx virtual hosts
nginx::resource::vhost { 'app.dev':
    index_files => ['index', 'index.html', 'index.htm', 'index.php'],
    server_name => 'localhost',
    www_root => $nginx_app_directory,
}

nginx::resource::location { 'app.dev.php':
    ensure => present,
    vhost => 'app.dev',
    location => '/',
    rewrite => '/(v[0-9\.]+)/?(.*)/?$ /index.php?$args last',
    try_files => [
        /index.php?$args /index /index.html /index.htm /public/index /public/index.html /public/index.htm /public/index.php?$args
    ]
}

nginx::resource::location { 'app.dev.php':
    ensure => present,
    vhost => 'app.dev',
    location => '~ \.php$',
    location_cfg_append => {
        fastcgi_index => 'index.php',
        fastcgi_param => '$document_root$fastcgi_script_name',
        fastcgi_intercept_errors => 'on',
        fastcgi_split_path_info => '^(.+\.php)(/.+)$',
        fastcgi_pass => 127.0.0.1:9000
      }    
}