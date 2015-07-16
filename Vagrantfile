Vagrant.configure(2) do |config|

  # If our host OS is windows, ensure that the vagrant-vbguest plugin is installed for mounting
  if Kernel.is_windows?
    unless Vagrant.has_plugin?("vagrant-vbguest")
      raise 'vagrant-vbguest is not installed! Use "vagrant plugin install vagrant-vbguest" to install!'
    end
  end

  # Ensure vagrant-hostsupdater is installed
  unless Vagrant.has_plugin?("vagrant-hostsupdater")
    raise 'vagrant-hostsupdater is not installed! Use "vagrant plugin install vagrant-hostsupdater" to install!'
  end

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "chef/centos-6.6"

  # Set a static IP
  config.vm.network :private_network, ip: "192.168.3.10"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # HTTP
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # MySQL
  config.vm.network "forwarded_port", guest: 3306, host: 3307

  # Redis
  config.vm.network "forwarded_port", guest: 6379, host: 6377

  # Mongo
  config.vm.network "forwarded_port", guest: 27018, host: 27018

  # Use vagrant-hostsupdater to alias the vhost on the guest machine
  config.vm.hostname = "app.dev"
  config.hostsupdater.aliases = ["app.loc"]

  # Mount the shared folder as the vagrant user
  config.vm.synced_folder "./", "/vagrant", :id => "vagrant-root", :owner => "vagrant", :group => "vagrant", :mount_options => ["dmode=775","fmode=775"]
  config.vm.synced_folder "../robin-api/", "/srv/www/", :id => "robin-api", :owner => "vagrant", :group => "vagrant", :mount_options => ["dmode=775","fmode=775"]

  # Install updates and core components
  config.vm.provision "shell", run: "once" do |shell|
    shell.path = "provisioning/bootstrap.sh"
  end

  # Install puppet/ruby dependencies
  config.vm.provision "shell", privileged: "false", run: "once" do |shell|
    shell.path = "provisioning/pp_dependencies.sh"
  end

  # Provision using Puppet
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "provisioning/puppet/manifests"
    puppet.module_path = "provisioning/puppet/modules"
    puppet.manifest_file  = ""
    puppet.options = ['--verbose']
  end

  # Shell script that runs on every boot
  config.vm.provision :shell, path: "provisioning/init.sh", run: "always", privileged: true
end

# Check if the host OS is windows. Thanks to http://stackoverflow.com/a/18452093
def Kernel.is_windows?
    # Detect if we are running on Windows
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform == 'mingw32'
end