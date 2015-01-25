# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    config.vm.box = 'ubuntu/trusty64'

    config.vm.provider :virtualbox do |v|
        v.memory = 1536
    end

    config.vm.network :forwarded_port, guest: 3000, host: 3000
    config.vm.network :forwarded_port, guest: 3001, host: 3001

    config.vm.synced_folder 'salt/roots/', '/srv/'
    config.vm.provision :salt do |salt|
        salt.minion_config = 'salt/minion'
        salt.run_highstate = true
    end
end
