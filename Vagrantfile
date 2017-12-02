Vagrant.configure("2") do |config|

	#config.vm.boot_timeout = 600
	config.vm.provider :virtualbox do |virtualbox|
		virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
		virtualbox.gui = false
	end

	config.vm.define "dc1" do |dc1|
	  dc1.vm.box = "gusztavvargadr/w16s"
	  dc1.vm.network "private_network", ip: "192.168.50.2"
	  dc1.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1"
	  dc1.vm.provision "shell", inline: "Copy-Item C:/vagrant/scripts/domain_controller.ps1 C:/"
	end
end
