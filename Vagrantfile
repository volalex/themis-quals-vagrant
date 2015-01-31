# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

def get_opts
    filename = './opts.yml'
    if File.exists? filename
        YAML.load File.open filename
    else
        {}
    end
end

def create_pillar(opts)
    filename = './salt/roots/pillar/share.sls'
    File.delete filename if File.exists? filename
    IO.write filename, opts.to_yaml
end

Vagrant.configure(2) do |config|
    config.vm.box = 'ubuntu/trusty64'

    opts = get_opts
    create_pillar opts

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
