{#############################################################################
# clusterbalancers:  use pillar data like a map file to create the balancers
#
# example pillar:

clusters:
  testcluster1:
    bmanagement: 0.0.0.0
    enableinstance: True
    status: running
    maddress: 230.0.0.9
    balanceraddr: '*'
    balancerport: 80
    balancerallowfrom:
      - 172.18.29
      - 172.21.16
      - 172.21.100
    adgroupaddress: 224.0.1.105
    adgroupport: 23364
    jspconfig:
      dev: 'true'
      checkinterval: 5
    launchhost: jboss-test1.xxxx.zzzz
    launchdir: /usr/local/testcluster1-deployments
    launchhandler: jboss-deploy.sls
    jbosshome: /usr/local/jboss-eap-6.4
    nodes:
      clusternode01:
        portoffset: 500
      clusternode02:
        portoffset: 600

#}

/etc/httpd/conf.d/mod_cluster.conf:
  file.managed:
    - source: salt://files/mod_cluster_dynamic.conf.jinja
    - template: jinja

