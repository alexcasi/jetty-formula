{% from 'jetty/map.jinja' import jetty, sls_block with context %}

{% set jetty_configs = ['jetty_config'] %}

jetty_user:
  user.present:
    - name: {{ jetty.user }}

jetty_group:
  group.present:
    - name: {{ jetty.group }}

jetty_config:
  file.managed:
    - name: {{ jetty.config_file }}
    - source: salt://jetty/files/config
    - template: jinja
    - context:
        jetty: {{ jetty | yaml() }}

{% for dir in ['etc', 'lib', 'logs', 'resources', 'start.d', 'webapps'] %}
jetty_base_{{ dir }}:
  file.directory:
    - name: {{ jetty.base_directory }}/{{ dir }}
    - user: {{ jetty.user }}
    - group: {{ jetty.group }}
    - makedirs: true
{% endfor %}

{% for name, opts in jetty.start_ini_files.items() %}
jetty_start.d_{{ name }}:
  file.managed:
    - name: {{ jetty.base_directory }}/start.d/{{ name }}.ini
    - user: {{ jetty.user }}
    - group: {{ jetty.group }}
    {{ sls_block(opts) | indent(4) }}
{% do jetty_configs.append('jetty_start.d_' + name) %}
{% endfor %}
