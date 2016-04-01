clusters:
  testcluster01:
    bmanagement: 0.0.0.0
    enableinstance: True
    status: running
#    status: dead
    maddress: 230.x.x.xx
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
    rsysloghost: 172.xx.xx.xx
    heapsettings: -Xms2048m -Xmx2048m -XX:MaxPermSize=256m
    cache:
       web:
         defaultstrategy: repl
#         defaultstrategy: dist
#         numcopies: 3
       hibernate:
         defaultstrategy: local-query 
#         defaultstrategy: replicated-cache 
    nodes:
{%- for n in range(1,5) %}
      clusternode0{{n}}:
        portoffset: {{n}}00
{%- endfor %}
