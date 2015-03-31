{% if salt['pillar.get']('themis:iptables_required', True) %}
iptables-persistent:
    pkg.installed: []

input_chain_policy:
    iptables.set_policy:
        - table: filter
        - chain: INPUT
        - policy: ACCEPT

forward_chain_policy:
    iptables.set_policy:
        - table: filter
        - chain: FORWARD
        - policy: DROP

output_chain_policy:
    iptables.set_policy:
        - table: filter
        - chain: OUTPUT
        - policy: ACCEPT

flush_filter_table_rules:
    iptables.flush:
        - table: filter
        - require:
            - iptables: input_chain_policy
            - iptables: forward_chain_policy
            - iptables: output_chain_policy

accept_input_related_established:
    iptables.insert:
        - position: 1
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - match: state
        - connstate: 'RELATED,ESTABLISHED'
        - save: True
        - require:
            - iptables: flush_filter_table_rules

accept_input_icmp:
    iptables.insert:
        - position: 2
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - proto: icmp
        - save: True
        - require:
            - iptables: flush_filter_table_rules

accept_input_local:
    iptables.insert:
        - position: 3
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - in-interface: lo
        - save: True
        - require:
            - iptables: flush_filter_table_rules

accept_input_port_ssh:
    iptables.insert:
        - position: 4
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - match: state
        - connstate: NEW
        - dport: 22
        - proto: tcp
        - save: True
        - require:
            - iptables: flush_filter_table_rules

accept_input_port_http:
    iptables.insert:
        - position: 5
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - match: state
        - connstate: NEW
        - dport: 80
        - proto: tcp
        - save: True
        - require:
            - iptables: flush_filter_table_rules

{% if salt['pillar.get']('themis:expose_supervisor', False) %}
accept_input_port_supervisor:
    iptables.insert:
        - position: 6
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - match: state
        - connstate: NEW
        - dport: 9001
        - proto: tcp
        - save: True
        - require:
            - iptables: flush_filter_table_rules
{% endif %}

reject_input_with_icmp_host_prohibited:
    iptables.insert:
        {% if salt['pillar.get']('themis:expose_supervisor', False) %}
        - position: 7
        {% else %}
        - position: 6
        {% endif %}
        - table: filter
        - chain: INPUT
        - jump: REJECT
        - reject-with: icmp-host-prohibited
        - save: True
        - require:
            - iptables: flush_filter_table_rules
{% endif %}
