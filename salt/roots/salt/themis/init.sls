/var/themis/quals-core:
    file.directory:
        - user: vagrant
        - group: vagrant
        - mode: 755
        - makedirs: True

https://github.com/aspyatkin/themis-quals-core.git:
    git.latest:
        - target: /var/themis/quals-core
        - user: vagrant
        - require:
            - pkg: git
            - file: /var/themis/quals-core

coffee-script@1.8.0:
    npm.installed:
        - require:
            - pkg: npm
