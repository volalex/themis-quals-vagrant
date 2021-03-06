/var/themis/quals:
    file.directory:
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 755
        - makedirs: True

git_themis_quals_core:
    git.latest:
        {% if salt['pillar.get']('git:ssh:github.com', None) %}
        - name: git@github.com:aspyatkin/themis-quals-core.git
        {% else %}
        - name: https://github.com/aspyatkin/themis-quals-core.git
        {% endif %}
        - target: /var/themis/quals/core
        {% if salt['pillar.get']('git:repositories:themis-quals-core', None) %}
        - revision: "{{ pillar['git']['repositories']['themis-quals-core'] }}"
        {% endif %}
        - user: "{{ pillar['system']['user'] }}"
        - require:
            - pkg: git
            - file: /var/themis/quals

graphicsmagick:
    pkg.installed

/var/themis/quals/core:
    npm.bootstrap:
        - require:
            - git: git_themis_quals_core
            - pkg: graphicsmagick

git_themis_quals_website:
    git.latest:
        {% if salt['pillar.get']('git:ssh:github.com', None) %}
        - name: git@github.com:aspyatkin/themis-quals-website.git
        {% else %}
        - name: https://github.com/aspyatkin/themis-quals-website.git
        {% endif %}
        - target: /var/themis/quals/website
        {% if salt['pillar.get']('git:repositories:themis-quals-website', None) %}
        - revision: "{{ pillar['git']['repositories']['themis-quals-website'] }}"
        {% endif %}
        - user: "{{ pillar['system']['user'] }}"
        - require:
            - pkg: git
            - file: /var/themis/quals

/var/themis/quals/website:
    npm.bootstrap:
        - require:
            - git: git_themis_quals_website

coffee-script@1.8.0:
    npm.installed:
        - require:
            - pkg: npm

bower:
    npm.installed:
        - require:
            - pkg: npm

/var/themis/quals/website/opts.yml:
    file.managed:
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 644
        - contents: |
            domain: "{{ pillar['themis']['domain'] }}"
            event:
                title: "{{ pillar['themis']['event']['title'] }}"
        - require:
            - git: git_themis_quals_website

gulp:
    npm.installed:
        - require:
            - pkg: npm
            - file: /var/themis/quals/website/opts.yml

/var/themis/quals/supervisor:
    file.directory:
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 755
        - makedirs: True
        - require:
            - file: /var/themis/quals

/var/themis/quals/core/.env:
    file.managed:
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 644
        - source: salt://templates/dotenv
        - template: jinja
        - defaults:
            secret: "{{ pillar['themis']['core']['secret'] }}"
            domain: "{{ pillar['themis']['domain'] }}"
            mongodb_uri: "mongodb://localhost/themis"
            logos_dir: "/var/themis/quals/logos"
        - require:
            - git: git_themis_quals_core

/var/themis/quals/supervisor/core.ini:
    file.managed:
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 644
        - source: salt://templates/core.ini
        - template: jinja
        - defaults:
            user: "{{ pillar['system']['user'] }}"
            processes: {{ salt['pillar.get']('themis:core:processes', 1) }}
            secret: "{{ pillar['themis']['core']['secret'] }}"
            domain: "{{ pillar['themis']['domain'] }}"
            mongodb_uri: "mongodb://localhost/themis"
            logos_dir: "/var/themis/quals/logos"
        - require:
            - file: /var/themis/quals/supervisor
            - npm: /var/themis/quals/core

/var/themis/quals/logos:
    file.directory:
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 755
        - makedirs: True
        - require:
            - file: /var/themis/quals

/var/themis/quals/supervisor/queue.ini:
    file.managed:
        - user: "{{ pillar['system']['user'] }}"
        - group: "{{ pillar['system']['group'] }}"
        - mode: 644
        - source: salt://templates/queue.ini
        - template: jinja
        - defaults:
            user: "{{ pillar['system']['user'] }}"
            processes: {{ salt['pillar.get']('themis:queue:processes', 1) }}
            mongodb_uri: "mongodb://localhost/themis"
            logos_dir: "/var/themis/quals/logos"
            domain: "{{ pillar['themis']['domain'] }}"
            email_sender: "{{ pillar['themis']['email_sender'] }}"
            mandrill_api_key: "{{ pillar['themis']['mandrill_api_key'] }}"
        - require:
            - file: /var/themis/quals/supervisor
            - npm: /var/themis/quals/core
