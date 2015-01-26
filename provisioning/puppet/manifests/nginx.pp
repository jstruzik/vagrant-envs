# Nginx
$nginx_app_directory = '/vagrant/app'
$nginx_user = 'vagrant'

# Nginx core configuration
class { 'nginx':
    log_format => 
    [
        main => '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"'
    ],
    daemon_user => $nginx_user,
    server_tokens => 'off',
    client_max_body_size => '5M',
    sendfile => 'on',
    keepalive_timeout => 65
}

# Ensure that a folder for the app exists
file { [$nginx_app_directory]:
    ensure => 'directory',
    owner  => $nginx_user,
    group  => $nginx_user
}

# Nginx virtual hosts
nginx::resource::vhost { 'app.dev':
    index_files => ['index', 'index.html', 'index.htm', 'index.php'],
    server_name => ['localhost'],
    www_root => $nginx_app_directory,
    use_default_location => false
}

# Nginx locations
nginx::resource::location { 'app.dev.php_root':
    ensure => present,
    vhost => 'app.dev',
    www_root => $nginx_app_directory,
    location => '/',
    try_files => [
        '$uri/', '$uri', '/index.php?$args'
    ]
}

nginx::resource::location { 'app.dev.php_file':
    ensure => present,
    vhost => 'app.dev',
    www_root => $nginx_app_directory,
    location => '~ \.php$',
    try_files => [
        '$uri = 404'
    ],
    location_cfg_append => {
        include => 'fastcgi_params',
        fastcgi_index => 'index.php',
        fastcgi_param => 'SCRIPT_FILENAME $document_root$fastcgi_script_name',
        fastcgi_intercept_errors => 'on',
        fastcgi_split_path_info => '^(.+\.php)(/.+)$',
        fastcgi_pass => '127.0.0.1:9000'
      }    
}