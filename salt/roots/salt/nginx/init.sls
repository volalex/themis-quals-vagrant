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
                server_name 'cdn.2015.volgactf-dev.org';
                listen 80;
                root /var/themis/quals/website/public/cdn;

                location ~* \.(?:ttf|ttc|otf|eot|woff|woff2)$ {
                    # expires 1M;
                    # access_log off;
                    # add_header Cache-Control "public";
                    add_header "Access-Control-Allow-Origin" "http://2015.volgactf-dev.org";
                }
            }
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/default:
    file.absent

/etc/nginx/sites-available/default:
    file.absent
