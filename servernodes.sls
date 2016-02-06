{% from 'lib/serverlib.sls' import serverinstance with context %}

{############################################################################# 
# servernodes:  use pillar data like a map file to create jboss server nodes 
#
# example pillar:

nodes:
  demonode01:
    bmanagement: 127.0.0.1
    portoffset: 300
    enableinstance: False
    status: dead
    bindaddress: 0.0.0.0
    maddress: 230.0.0.4
    jbossconfig: standalone-ha.xml
    jbosshome: /usr/local/jboss-eap-6.4
    launchhost: jboss-test1.zzzzz.zzzzz
    launchdir: /usr/local/demonode01-deployments

# example command line override:

# run it
salt jboss-test1.* state.sls servernodes pillar='{"overrides":{"testnode01":{"status":"running"}}}'
# debug it
salt jboss-test1.* state.show_sls servernodes pillar='{"overrides":{"testnode01":{"status":"running"}}}'

# example orchestration override:

stop-testnode01:
  salt.state.sls:
   - tgt: jboss-test1.zzzzz.zzzzz
   - sls: servernodes
   - pillar:
       overrides:
         testnode01:
           status: dead
#}

{% set overrides = salt['pillar.get']('overrides') %}

{% for instname, instprops in salt['pillar.get']('nodes', {}).iteritems() %}

{% set overridesspecific = overrides[ instname ] if overrides is defined and overrides[ instname ] is defined else {} %}

{% set bindaddrval = instprops['bindaddress'] if 'bindaddress' in instprops else '0.0.0.0' %}
{% set maddrval = instprops['maddress'] if 'maddress' in instprops else '230.0.0.4' %}
{% set bmgmtval = instprops['bmanagement'] if 'bmanagement' in instprops else '127.0.0.1' %}
{% set poffsetval = instprops['portoffset'] if 'portoffset' in instprops else False %}
{% set jbcfgval = instprops['jbossconfig'] if 'jbossconfig' in instprops else 'standalone-ha.xml' %}
{% set enableval = instprops['enableinstance'] if 'enableinstance' in instprops else True %}
{% set statusval = instprops['status'] if 'status' in instprops else 'running' %}
{% set statusval = overridesspecific['status'] if 'status' in overridesspecific else statusval %}

{{ serverinstance( instname,
                   instprops['jbosshome'],
                   bindaddress=bindaddrval,
                   maddress=maddrval,
                   bmanagement=bmgmtval,
                   portoffset=poffsetval,
                   jbossconfig=jbcfgval,  
                   enableinstance=enableval,
                   status=statusval
                  ) }}

{% endfor %}
