# -*- mode: ruby -*-
# vi: set ft=ruby :


# Make sure shared folders exist
FileUtils.mkdir_p(File.dirname(__FILE__)+'/sites')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/sites/000-default')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/sites/000-template')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/logs')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/databases')

# Set vagrant directory
vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure("2") do |config|

	# Default box
	config.vm.box = "bento/ubuntu-16.04"

	# IP - private network only
	config.vm.network :private_network, id: "apollo_primary", ip: "10.10.10.10"

	# Hostname
	config.vm.hostname = "apollo"
	config.ssh.forward_agent = true

	# This supresses the harmless but annoying 'stdin: is not a tty' error that is generated every time a shell script provisioner is run
	config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

	# Synced folders
	config.vm.synced_folder "logs", "/projects/logs", nfs: true
	config.vm.synced_folder "sites", "/projects/sites", nfs: true

	# Provisioning script
	config.vm.provision "shell", path: ".config/apollo-setup.sh"

	# Restart services on boot
	config.vm.provision :shell, inline: "sudo service mysql restart", run: "always"
	config.vm.provision :shell, inline: "sudo service nginx restart", run: "always"
	config.vm.provision :shell, inline: "sudo service php7.0-fpm restart", run: "always"
	
	# Backup databases on halt, if the vagrant-triggers plugin is installed
	if Vagrant.has_plugin? 'vagrant-triggers'

		config.trigger.before :halt do
			puts "Backing up your databases, this can take a few minutes..."
			run_remote  "bash /vagrant/.scripts/db-backup.sh"
		end

	else

		puts
		puts "The 'vagrant-triggers' plugin is not installed; this is required to back up your databases and whilst optional, is highly recommended"
		puts "You can install the plugin with this command:"
		puts
		puts "vagrant plugin install vagrant-triggers"
		puts

	end


	# VM Ware specific configuration
	config.vm.provider "vmware_fusion" do |v|
		v.vmx["memsize"] = "4096"
		v.vmx["numvcpus"] = "2"
		v.whitelist_verified = true
	end

	# Virtualbox specific configuration
	config.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--memory", 4096]
		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end

	# Load Customfile if it exists
	if File.exists?(File.join(vagrant_dir,'Customfile')) then
		eval(IO.read(File.join(vagrant_dir,'Customfile')), binding)
	end

end
