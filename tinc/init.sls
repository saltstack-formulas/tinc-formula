tinc:
  pkg:
    - installed
    - name: tinc
  service:
    - running
    - name: tinc
    - enable: True

{% if grains['os_family'] == 'RedHat' %}
/etc/init.d/tinc:
  file.managed:
    - source: salt://tinc/files/init.redhat
    - mode: 755
    - user: root
    - group: root
{% endif %}

/etc/tinc/nets.boot:
  file.managed:
    - mode: 755
    - user: root
    - group: root
    - replace: false
    - source: salt://tinc/files/nets.boot

{% for netname, network in pillar.get('tinc', {}).items() %}

/etc/tinc/{{ netname }}/hosts/:
  file.directory:
    - makedirs: true
    - mode: 755
    - user: root
    - group: root

  {% for hostname, host in network.items() %}

/etc/tinc/{{ netname }}/hosts/{{ hostname }}:
  file.managed:
    - mode: 755
    - user: root
    - group: root
    - source: salt://tinc/template/host.tmpl
    - template: 'jinja'
    - context:
      host_config: {{ host.get('host_config', {})|json }}
      RSAPublicKey: {{ host.get('RSAPublicKey')|json }}

    {%- set short_name = grains['id'].split('.') | first %}

    {%- if short_name == hostname %}
/etc/tinc/{{ netname }}/tinc.conf:
  file.managed:
    - mode: 755
    - user: root
    - group: root
    - source: salt://tinc/template/tinc.conf.tmpl
    - template: 'jinja'
    - context:
      tinc_config: {{ host.get('tinc_config')|json }}
      hostname: {{ hostname|json }}
    - watch_in:
      - service: tinc

      {%- if host.get('tinc_up', {}) is defined %}
/etc/tinc/{{ netname }}/tinc-up:
  file.managed:
    - mode: 755
    - user: root
    - group: root
    - contents_pillar: tinc:{{ netname }}:{{ hostname }}:tinc_up
      {%- endif %}

      {%- if host.get('tinc_down', {}) is defined %}
/etc/tinc/{{ netname }}/tinc-down:
  file.managed:
    - mode: 755
    - user: root
    - group: root
    - contents_pillar: tinc:{{ netname }}:{{ hostname }}:tinc_down
      {%- endif %}

      {%- if host.get('RSAPrivateKey', {}) is defined %}
/etc/tinc/{{ netname }}/rsa_key.priv:
  file.managed:
    - mode: 700
    - user: root
    - group: root
    - contents_pillar: tinc:{{ netname }}:{{ hostname }}:RSAPrivateKey
      {%- endif %}

    {% endif %}
  {% endfor %}
{% endfor %}
