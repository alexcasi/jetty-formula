{% from 'jetty/map.jinja' import jetty, os_family with context %}

{% set service_function = 'running' if jetty.service_enabled else 'dead' %}

{% if os_family == 'FreeBSD' %}
jetty_rc_user:
  sysrc.managed:
    - name: jetty_user
    - value: {{ jetty.user }}
    - watch_in:
      - jetty_service

jetty_rc_group:
  sysrc.managed:
    - name: jetty_group
    - value: {{ jetty.group }}
    - watch_in:
      - jetty_service
{% endif %}

jetty_service:
  service.{{ service_function }}:
    - name: {{ jetty.service }}
    - enable: {{ jetty.service_enabled }}
