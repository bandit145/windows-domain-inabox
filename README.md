# windows-domain-inabox
This is a Vagrant project that spins up a small windows domain (two DCs and two member servers)

AD\Administrator password is "vagrant"


## Requirements:

Vagrant

VirtualBox

## Run:

`vagrant up`

Note: You will have to run `vagrant reload` to get the synced folders to reconnect after server1/2 are rebooted for their domain join.
