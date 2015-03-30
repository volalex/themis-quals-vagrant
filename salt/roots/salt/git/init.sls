git:
    pkg.installed

{% for key, value in salt['pillar.get']('git:config', {}).iteritems() %}
git_config_{{ key }}:
    cmd.run:
        - name: 'git config --global {{ key }} "{{ value }}"'
        - user: "{{ pillar['system']['user'] }}"
        - require:
            - pkg: git
{% endfor %}

{% for key, value in salt['pillar.get']('git:ssh', {}).iteritems() %}
git_id_rsa_{{ key }}:
    file.managed:
        - name: "/home/{{ pillar['system']['user'] }}/.ssh/id_rsa_{{ key }}"
        - contents_pillar: 'git:ssh:{{ key }}:private_key'
        - user: "{{ pillar['system']['user'] }}"
        - mode: 600
        - require:
            - pkg: git

git_server_fingerprint_{{ key }}:
    ssh_known_hosts.present:
        - name: {{ key }}
        - user: "{{ pillar['system']['user'] }}"
        - fingerprint: {{ value['fingerprint'] }}
{% endfor %}

git_ssh_config:
    file.managed:
        - name: "/home/{{ pillar['system']['user'] }}/.ssh/config"
        - contents: |
            {% for key, value in salt['pillar.get']('git:ssh', {}).iteritems() %}
            Host {{ key }}
            HostName {{ key }}
            Port 22
            User git
            IdentityFile "/home/{{ pillar['system']['user'] }}/.ssh/id_rsa_{{ key }}"
            {% endfor %}
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 600
