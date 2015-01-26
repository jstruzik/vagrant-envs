#!/usr/bin/env bash

##############################
## Base OS-level operations ##
##############################

echo "Updating and install core packages"

# Update core packages via Yum
yum -y update

# Install some packages
yum -y install \
    yum-utils \
    scl-utils \
    gcc \
    openssl-devel

##################
## Ruby Install ##
##################

# Install the Ruby software-collections repo package
# Download and enable the Ruby software-collections repo
rpm -ivh https://www.softwarecollections.org/en/scls/rhscl/ruby193/epel-6-x86_64/download/rhscl-ruby193-epel-6-x86_64.noarch.rpm

# Install ruby via Yum
yum -y install ruby193-ruby ruby193-ruby-devel

# Set the new ruby version as the default for all users
echo "source /opt/rh/ruby193/enable" > $RUBY_PROFILE_SCRIPT_PATH
echo 'export PATH="/opt/rh/ruby193/root/usr/local/bin:$PATH"' >> $RUBY_PROFILE_SCRIPT_PATH

# Source our new profile
source $RUBY_PROFILE_SCRIPT_PATH

#############################
## Additional Repo Install ##
#############################

# Download and enable the EPEL repo
rpm -ivh https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Download the Remi repo (http://rpms.famillecollet.com/)
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Enable the Remi base "remi" repo to be queried by default
yum-config-manager --enable remi