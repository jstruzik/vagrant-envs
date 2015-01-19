#!/usr/bin/env bash

##############################
## Variables                ##
##############################

# The user's SSH key
RUBY_VERSION=2.0.0

##############################
## Base OS-level operations ##
##############################

echo "Updating and install core packages"

# Update core packages via Yum
yum -y update

# Install `yum-utils`
yum -y install yum-utils

# Get RVM
echo "Installing Ruby Version Manager"
curl -sSL https://get.rvm.io | bash -s $1

source /home/vagrant/.rvm/scripts/rvm

# Install and set the default version of Ruby
rvm use --install --default $RUBY_VERSION

# Setup Puppet
echo "Installing Puppet dependencies"
gem install bundler

(cd /vagrant/provisioning && exec bundle install)

#(cd /vagrant/provisioning/puppet && exec librarian-puppet install)


#############################
## Additional Repo Install ##
#############################

# Download and enable the EPEL repo
rpm -ivh https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Download the Remi repo (http://rpms.famillecollet.com/)
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Enable the Remi base "remi" repo to be queried by default
yum-config-manager --enable remi
#yum-config-manager --enable remi-php55 # PHP 5.5
#yum-config-manager --enable remi-php56 # PHP 5.6