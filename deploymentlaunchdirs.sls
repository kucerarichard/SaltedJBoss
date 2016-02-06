{#     
 # Minion create launch dirs for whatever clusters/servers minion has been assigned.
 #}
{% for clustername, clusterprops in salt['pillar.get']('clusters', {}).iteritems() %}
{{ clusterprops['launchdir'] }}:
  file.directory:
    - user: jboss
    - group: jboss
    - dir_mode: 755
    - file_mode: 644
{% endfor %}
{% for nodename, nodeprops in salt['pillar.get']('nodes', {}).iteritems() %}
{{ nodeprops['launchdir'] }}:
  file.directory:
    - user: jboss
    - group: jboss
    - dir_mode: 755
    - file_mode: 644
{% endfor %}

