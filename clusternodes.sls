{% from 'lib/serverlib.sls' import serverinstance with context %}

{############################################################################# 
# clusternodes:  use pillar data like a map file to create jboss cluster 
#
# example pillar:

clusters:
  testcluster01:
    bmanagement: 0.0.0.0
    enableinstance: True
    status: running
    maddress: 230.0.0.9
    jspconfig:
      dev: 'true'
      checkinterval: 5
    launchhost: jboss-test1.zzzzz.zzzzz
    launchdir: /usr/local/testcluster01-deployments
    bindaddress: 0.0.0.0
    jbossconfig: standalone-ha.xml
    jbosshome: /usr/local/jboss-eap-6.4
    nodes:
      testnode01:
        portoffset: 100
      testnode02:
        portoffset: 200
      testnode03:
        bindaddress: 0.0.0.0
        portoffset: 300
        bmanagement: 127.0.0.1
        enableinstance: False
        status: dead

# example command line overrides:

# run it
salt jboss-test1.* state.sls clusternodes pillar='{"overrides":{"testcluster01":{"status":"running"}}}'
salt jboss-test1.* state.sls clusternodes pillar='{"overrides":{"testcluster01":{"status":"dead"}}}'
# debug it
salt jboss-test1.* state.show_sls clusternodes pillar='{"overrides":{"testcluster01":{"status":"dead"}}}'

# example orchestration overrides

start-testcluster01:
  salt.state.sls:
   - tgt: jboss-test1.zzzzz.zzzzz
   - sls: clusternodes
   - pillar:
       overrides:
         testcluster01:
           status: running

#}

{% set overrides = salt['pillar.get']('overrides') %}
{% for clustername, clusterprops in salt['pillar.get']('clusters', {}).iteritems() %}

{% set overridesspecific = overrides[ clustername ] if overrides is defined and overrides[ clustername ] is defined else {} %}

{% set bindaddrval = clusterprops['bindaddress'] if 'bindaddress' in clusterprops else '0.0.0.0' %}
{% set maddrval = clusterprops['maddress'] if 'maddress' in clusterprops else '230.0.0.4' %}
{% set bmgmtval = clusterprops['bmanagement'] if 'bmanagement' in clusterprops else '127.0.0.1' %}
{% set poffsetval = clusterprops['portoffset'] if 'portoffset' in clusterprops else False %}
{% set jbcfgval = clusterprops['jbossconfig'] if 'jbossconfig' in clusterprops else 'standalone-ha.xml' %}
{% set enableval = clusterprops['enableinstance'] if 'enableinstance' in clusterprops else True %}
{% set statusval = clusterprops['status'] if 'status' in clusterprops else 'running' %}
{% set statusval = overridesspecific['status'] if 'status' in overridesspecific else statusval %}

{% for instname, instprops in clusterprops['nodes'].iteritems() %}

{% set bindaddrval = instprops['bindaddress'] if 'bindaddress' in instprops else bindaddrval %}
{% set bmgmtval = instprops['bmanagement'] if 'bmanagement' in instprops else bmgmtval %}
{% set poffsetval = instprops['portoffset'] if 'portoffset' in instprops else poffsetval %}
{% set enableval = instprops['enableinstance'] if 'enableinstance' in instprops else enableval %}
{% set statusval = instprops['status'] if 'status' in instprops else statusval %}

{{ serverinstance( instname,
                   clusterprops['jbosshome'],
                   bindaddress=bindaddrval,
                   maddress=maddrval,
                   bmanagement=bmgmtval,
                   portoffset=poffsetval,
                   jbossconfig=jbcfgval,  
                   enableinstance=enableval,
                   status=statusval,
                   clusterprops=clusterprops
                  ) }}

{% endfor %}

{# install the salt-call minion component of clustercommand 
 # in order to use jboss7 execution module on cluster minions. 
 # #}
{{ clusterprops['jbosshome'] }}/bin/command-{{ clustername }}-minion.sh:
  file.managed:
    - source: salt://files/scripts/clustercommand-minion.sh.jinja
    - template: jinja
    - user: jboss
    - group: jboss
    - mode: 750
    - defaults:
        clustername: {{ clustername }}
        clusterprops: {{ clusterprops }}

{% endfor %}
