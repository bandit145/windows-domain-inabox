Vagrant.configure("2") do |config|

	#config.vm.boot_timeout = 600
	config.vm.provider :virtualbox do |virtualbox|
		virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
		virtualbox.gui = false
	end

	config.vm.define "dc1" do |dc1|
	  dc1.vm.box = "gusztavvargadr/w16s"
	  dc1.vm.network "private_network", ip: "192.168.50.2"
	  dc1.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "dc2" do |dc2|
	  dc2.vm.box = "gusztavvargadr/w16s"
	  dc2.vm.network "private_network", ip: "192.168.50.3"
	  dc2.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "server1" do |server1|
	  server1.vm.box = "gusztavvargadr/w16s"
	  server1.vm.network "private_network", ip: "192.168.50.4"
	  server1.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "server2" do |server2|
	  server2.vm.box = "gusztavvargadr/w16s"
	  server2.vm.network "private_network", ip: "192.168.50.5"
	  server2.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "ansible_server" do |ansible|
		ansible.vm.box = "bento/centos-7.4"
		ansible.vm.network "private_network", ip: "192.168.50.6"
		ansible.vm.provision "shell", inline: "sudo yum -y install epel-release && sudo yum -y install python-pip"
		ansible.vm.provision "shell", inline: "sudo pip install ansible pywinrm"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && ansible-playbook deploy_domain.yml -i inventory"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && ansible-playbook domain_controller.yml -i inventory"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && ansible-playbook windows_core.yml -i inventory"
		ansible.vm.provision "shell", inline: "cd /vagrant/ansible && sudo ansible-playbook ansible_server.yml"
	end
end
