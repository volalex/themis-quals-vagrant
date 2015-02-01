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

    if opts.has_key? 'network'
        opts['network'].each do |key, value|
            options = Hash[value.map { |(k,v)| [k.to_sym, v] }]
            config.vm.network key, **options
        end
    end

    config.vm.synced_folder 'salt/roots/', '/srv/'
    config.vm.provision :salt do |salt|
        salt.minion_config = 'salt/minion'
        salt.run_highstate = true
    end
end
