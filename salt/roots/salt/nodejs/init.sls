nodejs:
    pkg.installed

node_symlink:
    file.symlink:
        - name: /usr/bin/node
        - target: /usr/bin/nodejs
        - require:
            - pkg: nodejs

npm:
    pkg.installed:
        - require:
            - pkg: nodejs
