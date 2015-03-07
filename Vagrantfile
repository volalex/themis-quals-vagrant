# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

def get_opts
    filename = File.join __dir__, 'opts.yml'
    if File.exists? filename
        YAML.load File.open filename
    else
        {}
    end
end

def create_pillar(opts)
    filename = File.join __dir__, 'salt', 'roots', 'pillar', 'share.sls'
    File.delete filename if File.exists? filename
    IO.write filename, opts.to_yaml
end

Vagrant.configure(2) do |config|
    config.vm.box = 'ubuntu/trusty64'

    opts = get_opts
    if opts.has_key? 'pillar'
        create_pillar opts['pillar']
    else
        create_pillar {}
    end

    config.vm.provider :virtualbox do |v|
        if opts.has_key? 'ram'
            v.memory = opts['ram']
        else
            v.memory = 1536
        end
    end

    if opts.has_key? 'network'
        opts['network'].each do |key, value|
            options = Hash[value.map { |(k,v)| [k.to_sym, v] }]
            config.vm.network key, **options
        end
    end

    config.vm.synced_folder File.join(__dir__, 'salt', 'roots'), '/srv'
    config.vm.synced_folder __dir__, '/vagrant', disabled: true

    config.vm.provision :salt do |salt|
        salt.minion_config = File.join __dir__, 'salt', 'minion'
        salt.log_level = 'info'
        salt.colorize = true
        salt.run_highstate = true
    end
end
