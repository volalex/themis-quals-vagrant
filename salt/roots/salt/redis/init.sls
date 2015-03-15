redis_ppa:
  pkgrepo.managed:
    - humanname: Redis PPA
    - name: ppa:rwky/redis
    - dist: trusty
    - file: /etc/apt/sources.list.d/redis.list
    - keyid: 5862E31D
    - keyserver: keyserver.ubuntu.com
    - require_in:
        - pkg: redis-server

redis-server:
    pkg.installed: []
    service.running:
        - enable: True
        - require:
            - pkg: redis-server
