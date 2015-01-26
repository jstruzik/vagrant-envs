$php_application_service = 'php-fpm'
$php_modules = ['opcache', 'pdo', 'pgsql', 'mbstring', 'mcrypt', 'bcmath', 'gmp', 'gd', 'openssl', 'xdebug']

# PHP install configuration
class { 'php':
    package             => 'php-fpm',

    #install_options     => [{'--enablerepo' => 'remi-php55'}],

    service             => $php_application_service,
    service_autorestart => true,
}

# PHP modules
php::module { $php_modules: }

php::pecl::module { "mongo": }

# PHP Tools
exec { 'composer-install':
    command => 'curl -s http://getcomposer.org/installer | php -- --install-dir=bin --filename=composer'
}

# PHP custom configuration
file { "/etc/php.d/custom.ini":
    owner  => root,
    group  => root,
    mode   => 664,
    source => "/vagrant/provisioning/puppet/conf/php/custom.ini",
}

file { "/etc/php5/fpm/pool.d/www.conf":
    owner  => root,
    group  => root,
    mode   => 664,
    source => "/vagrant/provisioning/puppet/conf/php/php-fpm/www.conf",
}

# PHP-FPM service
service { $php_application_service:
    ensure => running,
}