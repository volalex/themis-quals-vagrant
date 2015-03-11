/var/themis/quals:
    file.directory:
        - user: vagrant
        - group: vagrant
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
        - user: vagrant
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
        - user: vagrant
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
        - user: vagrant
        - group: vagrant
        - mode: 644
        - contents: |
            domain: "{{ pillar['themis']['domain'] }}"
        - require:
            - git: git_themis_quals_website

gulp:
    npm.installed:
        - require:
            - pkg: npm
            - file: /var/themis/quals/website/opts.yml

/var/themis/quals/supervisor:
    file.directory:
        - user: vagrant
        - group: vagrant
        - mode: 755
        - makedirs: True
        - require:
            - file: /var/themis/quals

/var/themis/quals/supervisor/core.ini:
    file.managed:
        - user: vagrant
        - group: vagrant
        - mode: 644
        - source: salt://templates/core.ini
        - template: jinja
        - defaults:
            processes: {{ salt['pillar.get']('themis:core:processes', 1) }}
            secret: "{{ pillar['themis']['core']['secret'] }}"
            domain: "{{ pillar['themis']['domain'] }}"
            mongodb_uri: "mongodb://localhost/themis"
        - require:
            - file: /var/themis/quals/supervisor
            - npm: /var/themis/quals/core
