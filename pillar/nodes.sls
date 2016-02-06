nodes:
  testnode01:
    bmanagement: 0.0.0.0
    portoffset: 100
    enableinstance: True
    status: dead
    maddress: 230.0.0.9
    jspconfig:
      dev: 'true'
      checkinterval: 5
    jbosshome: /usr/local/jboss-eap-6.4
    launchhost: jboss-test1.zzzzz.zzzzz
    launchdir: /usr/local/testnode01-deployments
    launchhandler: jboss-deploy.sls
  testnode02:
    bmanagement: 0.0.0.0
    portoffset: 200
    enableinstance: True
    status: dead
    maddress: 230.0.0.9
    jspconfig:
      dev: 'true'
      checkinterval: 5
    jbosshome: /usr/local/jboss-eap-6.4
    launchhost: jboss-test1.zzzzz.zzzzz
    launchdir: /usr/local/testnode02-deployments
    launchhandler: jboss-deploy.sls
