include:
  - tinc

{% for netname, network in pillar.get('tinc', {}).items() %}
  {% for hostname, host in network.items() %}

{{ hostname }}-host-entry:
  host.present:
    - ip: {{ host['host_config']['Subnet'].split('/') | first }}
    - names:
      - {{ hostname + "." + netname }}

  {% endfor %}
{% endfor %}
