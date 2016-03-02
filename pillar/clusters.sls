clusters:
  testcluster01:
    bmanagement: 0.0.0.0
    enableinstance: True
    status: running
    maddress: 230.0.0.11
    balanceraddr: '*'
    balancerport: 80
    balancerallowfrom:
      - 123.34.56
      - 124.56.78
      - 123.34.23
    adgroupaddress: 224.0.1.106 
    adgroupport: 23364
    jspconfig:
      dev: 'true'
      checkinterval: 5
    launchhost: jboss-test1.zzzzz.zzzzz
    launchdir: /usr/local/testcluster01-deployments
    launchhandler: jboss-deploy.sls
    jbosshome: /usr/local/jboss-eap-6.4
    rsysloghost: 123.45.67.89
    cache:
       web:
         defaultstrategy: repl
#         defaultstrategy: dist
#         numcopies: 3
       hibernate:
         defaultstrategy: local-query 
#         defaultstrategy: replicated-cache 
    nodes:
      clusternode01:
        portoffset: 500
      clusternode02:
        portoffset: 600
      clusternode03:
        portoffset: 700
      clusternode04:
        portoffset: 800


