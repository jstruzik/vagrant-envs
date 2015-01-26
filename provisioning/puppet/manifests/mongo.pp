# MongoDB

# MongoDB Setup
class {'::mongodb::server':
  port    => 27018,
  verbose => true,
}