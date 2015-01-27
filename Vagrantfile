Vagrant.configure(2) do |config|

  # If our host OS is windows, ensure that the vagrant-vbguest plugin is installed for mounting
  if Kernel.is_windows?
    unless Vagrant.has_plugin?("vagrant-vbguest")
      raise 'vagrant-vbguest is not installed! Use "vagrant plugin install vagrant-vbguest" to install!'
    end
  end

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "chef/centos-6.6"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.synced_folder "./", "/vagrant", :id => "vagrant-root", :owner => "vagrant", :group => "vagrant", :mount_options => ["dmode=775","fmode=775"]

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
end

# Check if the host OS is windows. Thanks to http://stackoverflow.com/a/18452093
def Kernel.is_windows?
    # Detect if we are running on Windows
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform == 'mingw32'
end