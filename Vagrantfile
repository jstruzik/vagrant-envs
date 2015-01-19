Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "chef/centos-6.6"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Allows the box to SSH into other services
  # See https://developer.github.com/guides/using-ssh-agent-forwarding/
  # See http://www.scottyewell.com/setting-vagrant-ssh-forwarding/
  config.ssh.forward_agent = true
  config.ssh.private_key_path = "~/.ssh/id_rsa"

  # Install updates and core components
  config.vm.provision "shell", run: "once" do |shell|
    shell.path = "provisioning/bootstrap.sh"
  end

  # Provision using Puppet
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "provisioning/puppet/manifests"
    puppet.module_path = "provisioning/puppet/modules"
    puppet.manifest_file  = "default.pp"
  end
end