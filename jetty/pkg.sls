{% from 'jetty/map.jinja' import jetty with context %}

jetty_install:
  pkg.installed:
    - name: {{ jetty.package }}
