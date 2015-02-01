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
                server_name '2015.volgactf-dev.org';
                listen 80;
                location / {
                    root /var/themis/quals/website/public/html;
                    rewrite ^(.*)$ /index.html break;
                }
            }

            server {
                server_name '2015-js.volgactf-dev.org';
                listen 80;
                location / {
                    root /var/themis/quals/website/public/js;
                }
            }

            server {
                server_name '2015-css.volgactf-dev.org';
                listen 80;
                location / {
                    root /var/themis/quals/website/public/css;
                }
            }
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/default:
    file.absent

/etc/nginx/sites-available/default:
    file.absent
