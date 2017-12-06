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
	config.vm.provision "shell", path: ".scripts/db-backup.sh", run: "always"
	config.vm.provision "shell", path: ".scripts/restart-services.sh", run: "always"

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
