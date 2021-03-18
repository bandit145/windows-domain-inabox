Vagrant.configure("2") do |config|

	config.vm.provider :virtualbox do |virtualbox|
		virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
		virtualbox.gui = false
		virtualbox.memory = 2048
	end

	config.vm.define "dc1" do |dc1|
	  dc1.vm.box = "gusztavvargadr/windows-server-standard-core"
	  dc1.vm.network "private_network", ip: "192.168.50.2"
	  dc1.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "dc2" do |dc2|
	  dc2.vm.box = "gusztavvargadr/windows-server-standard-core"
	  dc2.vm.network "private_network", ip: "192.168.50.3"
	  dc2.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "server1" do |server1|
	  server1.vm.box = "gusztavvargadr/windows-server"
	  server1.vm.network "private_network", ip: "192.168.50.4"
	  server1.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "server2" do |server2|
	  server2.vm.box = "gusztavvargadr/windows-server"
	  server2.vm.network "private_network", ip: "192.168.50.5"
	  server2.vm.provision "shell", inline: "C:/vagrant/scripts/ansible_setup.ps1 -ForceNewSSLCert"
	end

	config.vm.define "ansible_server" do |ansible|
		ansible.vm.box = "bento/centos-8"
		ansible.vm.network "private_network", ip: "192.168.50.6"
		ansible.vm.provision "shell", inline: "sudo service network restart"
		ansible.vm.provision "shell", inline: "sudo yum -y install epel-release && sudo yum -y install python3 python3-pip python3-virtualenv"
		ansible.vm.provision "shell", inline: "virtualenv -p python3 venv && venv/bin/pip3 install ansible==2.9.15 pywinrm"
		ansible.vm.provision "shell", inline: "source venv/bin/activate && cd /vagrant/ansible && ansible-playbook deploy_domain.yml -i inventory"
		ansible.vm.provision "shell", inline: "source venv/bin/activate && cd /vagrant/ansible && ansible-playbook domain_controller.yml -i inventory"
		ansible.vm.provision "shell", inline: "source venv/bin/activate && cd /vagrant/ansible && ansible-playbook windows_core.yml -i inventory"
		ansible.vm.provision "shell", inline: "source venv/bin/activate && cd /vagrant/ansible && ansible-playbook -b ansible_server.yml -e ansible_python_interpreter=/usr/bin/python3"
	end
end
