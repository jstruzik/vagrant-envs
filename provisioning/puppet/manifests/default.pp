# Puppet configuration

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

Package {
    # Fix for deprecation notice with Yum
    # (see https://inuits.eu/blog/puppet-361-depreciation-warning)
    allow_virtual => true,
}
