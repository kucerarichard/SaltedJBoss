{#
 # simple logging via logger command
 # direct-to-syslog logging is done in the server xml config.
 #}
{% macro loggerbundle(path2logfile,facility,priority,tag) -%}
/opt/logger.local/{{ tag }}-logger.sh:
    file.managed:
        - makedirs: True
        - source: salt://files/rsyslog/logger.sh.jinja
        - user: root
        - group: root
        - mode: 755
        - template: jinja
        - defaults:
              path2logfile: {{ path2logfile }}
              facility: {{ facility }}
              priority: {{ priority }}
              tag: {{ tag }}
/etc/rsyslog.d/{{ tag }}-logger.conf:
    file.managed:
        - makedirs: True
        - source: salt://files/rsyslog/logger.conf.jinja
        - user: root
        - group: root
        - mode: 644
        - template: jinja
        - defaults:
              facility: {{ facility }}
              priority: {{ priority }}
{%- endmacro %}

{% macro logger(path2logfile,facility,priority,tag) -%}
/opt/logger.local/{{ tag }}-logger.sh:
    file.managed:
        - makedirs: True
        - source: salt://files/rsyslog/logger.sh.jinja
        - user: root
        - group: root
        - mode: 755
        - template: jinja
        - defaults:
              path2logfile: {{ path2logfile }}
              facility: {{ facility }}
              priority: {{ priority }}
              tag: {{ tag }}
{%- endmacro %}

