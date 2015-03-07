git:
    pkg.installed

{% for key, value in salt['pillar.get']('git:config', {}).iteritems() %}
git_config_{{ key }}:
    cmd.run:
        - name: 'git config --global {{ key }} "{{ value }}"'
        - user: vagrant
        - require:
            - pkg: git
{% endfor %}

{% for key, value in salt['pillar.get']('git:ssh', {}).iteritems() %}
git_id_rsa_{{ key }}:
    file.managed:
        - name: /home/vagrant/.ssh/id_rsa_{{ key }}
        - contents_pillar: 'git:ssh:{{ key }}:private_key'
        - user: vagrant
        - mode: 600
        - require:
            - pkg: git

git_server_fingerprint_{{ key }}:
    ssh_known_hosts.present:
        - name: {{ key }}
        - user: vagrant
        - fingerprint: {{ value['fingerprint'] }}
{% endfor %}

git_ssh_config:
    file.managed:
        - name: /home/vagrant/.ssh/config
        - contents: |
            {% for key, value in salt['pillar.get']('git:ssh', {}).iteritems() %}
            Host {{ key }}
            HostName {{ key }}
            Port 22
            User git
            IdentityFile /home/vagrant/.ssh/id_rsa_{{ key }}
            {% endfor %}
        - user: vagrant
        - group: staff
        - model: 600
        - require:
            {% for key, value in salt['pillar.get']('git:ssh', {}).iteritems() %}
            - file: git_id_rsa_{{ key }}
            - ssh_known_hosts: git_server_fingerprint_{{ key }}
            {% endfor %}
