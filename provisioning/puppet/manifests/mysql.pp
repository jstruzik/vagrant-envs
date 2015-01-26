# MYSQL

# Custom configuration
$override_options = {
  'mysqld' => {
    'default-time-zone' => '+00:00',
    'sql_mode' => 'ALLOW_INVALID_DATES'
  }
}

# Mysql setup
class { '::mysql::server':
  root_password    => 'root',
  override_options => $override_options
}
