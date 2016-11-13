{% from 'jetty/map.jinja' import jetty %}
{% from 'jetty/config.sls' import jetty_configs %}
{% from 'jetty/service.sls' import service_function %}

include:
  - jetty.pkg
  - jetty.config
  - jetty.service

extend:
  jetty_service:
    service:
      - watch:
        - file: jetty_config
      - require:
        - file: jetty_config
  jetty_config:
    file:
      - require:
        - pkg: jetty_install

{% macro file_requisites(states) %}
      {%- for state in states %}
      - file: {{ state }}
      {%- endfor -%}
{% endmacro %}

{% if jetty_configs %}
jetty_service_reload:
  service.{{ service_function }}:
    - name: {{ jetty.service }}
    - reload: true
    - use:
      - service: jetty_service
    - watch:
      {{ file_requisites(jetty_configs) }}
    - require:
      {{ file_requisites(jetty_configs) }}
      - service: jetty_service
{% endif %}
