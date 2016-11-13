{% from 'jetty/map.jinja' import jetty %}
{% from 'jetty/config.sls' import jetty_configs %}
{% from 'jetty/service.sls' import service_function %}

{% macro file_requisites(states) %}
{%- for state in states %}
- file: {{ state }}
{%- endfor -%}
{% endmacro %}

include:
  - jetty.pkg
  - jetty.config
  - jetty.service

extend:
  jetty_service:
    service:
      - watch:
        {{ file_requisites(jetty_configs) | indent(8) }}
      - require:
        {{ file_requisites(jetty_configs) | indent(8) }}

  jetty_config:
    file:
      - require:
        - pkg: jetty_install
