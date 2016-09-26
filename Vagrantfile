# -*- mode: ruby -*-
# vi: set ft=ruby :

FileUtils.mkdir_p(File.dirname(__FILE__)+'/sites')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/sites/000-default')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/sites/000-template')
FileUtils.mkdir_p(File.dirname(__FILE__)+'/logs')

Vagrant.configure("2") do |config|

	config.vm.box = "boxcutter/ubuntu1604"

	config.vm.network :private_network, ip: "10.10.10.10"

	config.vm.hostname = "apollo"
	config.ssh.forward_agent = true
	
	config.vm.synced_folder "logs", "/projects/logs"
	config.vm.synced_folder "sites", "/projects/sites"

	config.vm.provision "shell", path: ".config/apollo-setup.sh"

#	config.vm.provider :virtualbox do |v|
#		v.customize ["modifyvm", :id, "--memory", 2048]
#		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
#	end

	config.vm.provider "vmware_fusion" do |v|
		v.vmx["memsize"] = "2048"
		v.vmx["numvcpus"] = "2"
	end

end
