supervisord_config:
    file.managed:
        - name: /etc/supervisor/supervisord.conf
        - source: salt://templates/supervisord.conf
        - mode: 644
        - template: jinja
        - makedirs: True
        - defaults:
            includes:
                - /var/themis/quals/supervisor/*.ini
        - require:
            - file: /var/themis/quals/supervisor

supervisord_service:
    file.managed:
        - name: /etc/init/supervisord.conf
        - source: salt://templates/supervisord.service
        - mode: 755

supervisor:
    pip.installed: []

supervisord:
    service.running:
        - enable: True
        - require:
            - pip: supervisor
            - file: supervisord_service
            - file: supervisord_config
