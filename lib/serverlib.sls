{################################################### 
# HOW-TO call serverinstance()

{% from 'lib/serverlib.sls' import serverinstance with context %}

Ad hoc calls from state files:

{{ serverinstance('demonode234567',
                   bmanagement='0.0.0.0',
                   portoffset=100,
                   enableinstance=True) }}

{{ serverinstance('testnode234567',
                   bmanagement='0.0.0.0',
                   enableinstance=False,
                   status='dead') }}

Pillar-driven calls:

The top-level servernodes/clusternodes state will use pillar data like a map file
to define the server instance.  It has its own defaults coded there 
(to accomodate the pillar layer). servernodes/clusternodes then calls this macro 
to generate the server instances.

#}

{# GLOBALS
   The purpose of using a global list to transport a
   setting value from within a template support macro
   is to make the list of config file calls less verbose.
   Macros cannot set anything outside of their own scope,
   but they can append to an array. #}
{% set globalJbosshome = [] %}
{% set globalInstancehome = [] %}

{% macro serverinstance(instancehome,jbosshome,bindaddress='0.0.0.0',maddress='230.0.0.4',bmanagement='127.0.0.1',portoffset=False,jbossconfig='standalone-ha.xml',enableinstance=True,status='running',clusterprops=False) -%}

{# Using an array to change values had to be done due to limitations of Jinja2 #}
{# be sure to get the current value by using [-1] for last element of array #}
{% if globalInstancehome.append( instancehome ) %}{% endif %}
{% if globalJbosshome.append( jbosshome ) %}{% endif %}

{{ instancedirs( instancehome ) }}

{{ jinjacfgfile('logging.properties',serverlogpath=jbosshome+'/'+instancehome+'/log/server.log') }}
{{ jinjacfgfile( jbossconfig, clusterprops=clusterprops ) }}
{{ jinjacfgfile('application-roles.properties') }}
{{ jinjacfgfile('application-users.properties') }}
{{ jinjacfgfile('mgmt-groups.properties') }}
{{ jinjacfgfile('mgmt-users.properties') }}

{{ jbosshome }}/bin/standalone-{{ instancehome }}.conf:
  file.managed:
    - source: salt://files/jboss-as-standalone.conf.jinja
    - template: jinja
    - mode: 755
    - defaults:
        instancename: {{ instancehome }}
        jbosshome: {{ jbosshome }}
        clusterprops: {{ clusterprops }}

/etc/jboss-as/jboss-as-{{ instancehome }}.conf:
  file.managed:
    - source: salt://files/jboss-as-etc.conf.jinja
    - template: jinja
    - mode: 755
    - defaults:
        instancename: {{ instancehome }}
        jbosshome: {{ jbosshome }}

/etc/init.d/jboss-as-{{ instancehome }}.sh:
  file.managed:
    - source: salt://files/jboss-as-standalone.sh.jinja
    - template: jinja
    - mode: 755
    - defaults:
        instancename: {{ instancehome }}
        jbossconfig: {{ jbossconfig }}
        jbosshome: {{ jbosshome }}
        portoffset: {{ portoffset }}
        instanceipaddress: {{ bindaddress }}
        multicastaddress: {{ maddress }}
        mgmtipaddress: {{ bmanagement }}
jboss-as-{{ instancehome }}.sh:
  service.{{ status }}:
{%- if enableinstance %}
    - enable: True
{%- else %}
    - enable: False
{% endif -%}

{%- endmacro %}

{% macro jinjacfgfile(cfgfilename,instancehome=False,serverlogpath=False,clusterprops=False) -%}
{% if not instancehome %}
{% set instancehome = globalInstancehome[-1] %}
{% endif %}
{% set jbosshome = globalJbosshome[-1] %}
{{ jbosshome }}/{{ instancehome }}/configuration/{{ cfgfilename }}:
  file.managed:
    - source: salt://files/{{ cfgfilename }}.jinja
    - template: jinja
    - user: jboss
    - group: jboss
    - mode: 644
    - defaults:
        servernodename: {{ instancehome }}
        clusterprops: {{ clusterprops }}
{%- if serverlogpath %}
        serverlogpath: {{ serverlogpath }}
{% endif -%}
{%- endmacro %}

{% macro instancedirs(instancehome) -%}
{% set jbosshome = globalJbosshome[-1] %}
{{ instancehome }}_inst_dirs:
  file.directory:
    - user: jboss
    - group: jboss
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - names:
      - {{ jbosshome }}/{{ instancehome }}
      - {{ jbosshome }}/{{ instancehome }}/data
      - {{ jbosshome }}/{{ instancehome }}/data/content
      - {{ jbosshome }}/{{ instancehome }}/data/timer-service-data
      - {{ jbosshome }}/{{ instancehome }}/data/tx-object-store
      - {{ jbosshome }}/{{ instancehome }}/data/tx-object-store/ShadowNoFileLockStore
      - {{ jbosshome }}/{{ instancehome }}/data/tx-object-store/ShadowNoFileLockStore/defaultStore
      - {{ jbosshome }}/{{ instancehome }}/configuration
      - {{ jbosshome }}/{{ instancehome }}/configuration/standalone_xml_history
      - {{ jbosshome }}/{{ instancehome }}/log
      - {{ jbosshome }}/{{ instancehome }}/tmp
      - {{ jbosshome }}/{{ instancehome }}/deployments
      - {{ jbosshome }}/{{ instancehome }}/lib
      - {{ jbosshome }}/{{ instancehome }}/lib/ext
{%- endmacro %}
