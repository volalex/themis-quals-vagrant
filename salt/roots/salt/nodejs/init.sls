nodejs:
    pkg.installed

nodejs-legacy:
    pkg.installed

npm:
    pkg.installed:
        - require:
            - pkg: nodejs
            - pkg: nodejs-legacy
