nginx_ppa:
  pkgrepo.managed:
    - humanname: Nginx PPA
    - name: ppa:nginx/stable
    - dist: trusty
    - file: /etc/apt/sources.list.d/nginx.list
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com
    - require_in:
        - pkg: nginx

nginx:
    pkg.installed: []
    service.running:
        - enable: True
        - require:
            - pkg: nginx

/etc/nginx/conf.d/themis-quals-website.conf:
    file.managed:
        - user: root
        - group: root
        - mode: 644
        - source: salt://templates/themis-quals.conf
        - template: jinja
        - defaults:
            domain: "{{ pillar['themis']['domain'] }}"
            processes: {{ salt['pillar.get']('themis:core:processes', 1) }}
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/default:
    file.absent

/etc/nginx/sites-available/default:
    file.absent
