Vagrant.configure("2") do |config|

	config.vm.provider :virtualbox do |virtualbox|
		virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
		virtualbox.gui = false
		#virtualbox.memory = 2048
	end

	config.vm.define "dc1" do |dc1|
	  dc1.vm.box = "gusztavvargadr/windowsservercore2016"
	  dc1.vm.network "private_network", ip: "192.168.50.2"
	  dc1.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	  dc1.vm.provider :virtualbox do |virtualbox|
	    virtualbox.memory = 2048
	    virtualbox.cpus = 2
	  end
	end

	config.vm.define "dc2" do |dc2|
	  dc2.vm.box = "gusztavvargadr/windowsservercore2016"
	  dc2.vm.network "private_network", ip: "192.168.50.3"
	  dc2.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	  dc2.vm.provider :virtualbox do |virtualbox|
	    virtualbox.memory = 2048
	    virtualbox.cpus = 2
	  end
	end

	config.vm.define "server1" do |server1|
	  server1.vm.box = "gusztavvargadr/windowsservercore2016"
	  server1.vm.network "private_network", ip: "192.168.50.4"
	  server1.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	  server1.vm.provider :virtualbox do |virtualbox|
	    virtualbox.memory = 2048
	    virtualbox.cpus = 2
	  end
	end

	config.vm.define "server2" do |server2|
	  server2.vm.box = "gusztavvargadr/windowsservercore2016"
	  server2.vm.network "private_network", ip: "192.168.50.5"
	  server2.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	  server2.vm.provider :virtualbox do |virtualbox|
	    virtualbox.memory = 2048
	    virtualbox.cpus = 2
	  end
	end

	config.vm.define "linux_server" do |linux|
		linux.vm.box = "bento/centos-7"
		linux.vm.network "private_network", ip: "192.168.50.6"
	end

	config.vm.define "ansible_server" do |ansible|
		ansible.vm.box = "bento/centos-7"
		ansible.vm.network "private_network", ip: "192.168.50.7"
		ansible.vm.provision "shell", inline: "sudo yum -y install epel-release && sudo yum -y install python-pip sshpass"
		ansible.vm.provision "shell", inline: "sudo pip install ansible==2.7.5 pywinrm"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && ansible-playbook deploy_domain.yml -i inventory"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && ansible-playbook domain_controller.yml -i inventory"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && ansible-playbook windows_core.yml -i inventory"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && ansible-playbook ansible_server.yml -i inventory"
	end
end
