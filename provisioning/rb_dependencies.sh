# Setup Puppet
echo "Installing Puppet dependencies"
gem install bundler

(cd /vagrant/provisioning && exec bundle install)

(cd /vagrant/provisioning/puppet && exec librarian-puppet install)