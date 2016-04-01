{#     
 # 1. Minion create launch dirs for whatever clusters/servers minion has been assigned.
 # 2. Put the manual deployment scripts in the launch dir(mitigate beacon failure).
 # To run just this state (and not the whole clusterbuilder orchestration)
 # use this syntax to install on launchdir minion:
 #  salt jboss-prod1 state.sls deployment.launchdirs pillar="{miniontarget: 'jboss-prod[12]'}"
 #}
{% for clustername, clusterprops in salt['pillar.get']('clusters', {}).iteritems() %}
{{ clusterprops['launchdir'] }}:
  file.directory:
    - user: jboss
    - group: jboss
    - dir_mode: 755
    - file_mode: 644

{%- set gotdeployments =  salt['pillar.get']('deployments') %}
{%- if gotdeployments is defined and gotdeployments %}
{%- for deploymentname, deploymentprops in gotdeployments.iteritems() %}
{%-   if deploymentprops['cluster'] is defined and deploymentprops['cluster'] == clustername %}
{%-     set beacondeploydir = salt['pillar.get']('clusters')[ deploymentprops['cluster'] ]['launchdir'] %}
{%-     if deploymentprops['format'] == 'exploded' or deploymentprops['format'] == 'archive' %}
{%-     set gotsourcepath =  beacondeploydir+'/'+deploymentname %}
{%-     if deploymentprops['format'] == 'exploded' %}
{%-       set gotsourcepath =  gotsourcepath+'.dodeploy' %}
{%-     endif %}

{{ beacondeploydir }}/{{ deploymentname }}-dodeploy.sh: 
  file.managed:
    - source: salt://files/scripts/do-deploy.sh.jinja
    - template: jinja
    - user: jboss
    - group: jboss
    - mode: 755
    - defaults:
        sourcepath: {{ gotsourcepath }}
        miniontarget: {{  salt['pillar.get']('miniontarget') }}

{%-     endif -%}
{%-   endif %}
{%  endfor -%}
{%- endif %}

{% endfor %}
{% for nodename, nodeprops in salt['pillar.get']('nodes', {}).iteritems() %}
{{ nodeprops['launchdir'] }}:
  file.directory:
    - user: jboss
    - group: jboss
    - dir_mode: 755
    - file_mode: 644

{%- set gotdeployments =  salt['pillar.get']('deployments') %}
{%- if gotdeployments is defined and gotdeployments %}
{%- for deploymentname, deploymentprops in gotdeployments.iteritems() %}
{%-   if deploymentprops['node'] is defined and deploymentprops['node'] == nodename %}
{%-     set beacondeploydir = salt['pillar.get']('nodes')[ deploymentprops['node'] ]['launchdir']  %}
{%-     if deploymentprops['format'] == 'exploded' or deploymentprops['format'] == 'archive' %}

{{ beacondeploydir }}/{{ deploymentname }}-dodeploy.sh:
  file.managed:
    - source: salt://files/scripts/do-deploy.sh.jinja
    - template: jinja
    - user: jboss
    - group: jboss
    - mode: 755
    - defaults:
        sourcepath: {{ beacondeploydir }}/{{ deploymentname }}
        miniontarget: {{  salt['pillar.get']('miniontarget') }}

{%-     endif -%}
{%-   endif %}
{%  endfor -%}
{%- endif %}

{% endfor %}

