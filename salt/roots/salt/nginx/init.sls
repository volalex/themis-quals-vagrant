nginx:
    pkg:
        - installed
    service:
        - running

/etc/nginx/conf.d/themis-quals-website.conf:
    file.managed:
        - user: root
        - group: root
        - mode: 644
        - contents: |
            server {
                listen 3001;
                location / {
                    root /var/themis/quals/website/public;
                }
            }
        - require:
            - pkg: nginx
