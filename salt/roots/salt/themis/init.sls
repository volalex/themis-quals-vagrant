/var/themis/quals:
    file.directory:
        - user: vagrant
        - group: vagrant
        - mode: 755
        - makedirs: True

https://github.com/aspyatkin/themis-quals-core.git:
    git.latest:
        - target: /var/themis/quals/core
        - user: vagrant
        - require:
            - pkg: git
            - file: /var/themis/quals

https://github.com/aspyatkin/themis-quals-website.git:
    git.latest:
        - target: /var/themis/quals/website
        - user: vagrant
        - require:
            - pkg: git
            - file: /var/themis/quals

coffee-script@1.8.0:
    npm.installed:
        - require:
            - pkg: npm

bower:
    npm.installed:
        - require:
            - pkg: npm

gulp:
    npm.installed:
        - require:
            - pkg: npm
