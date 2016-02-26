# SaltedJBoss
SaltStack-based JBoss Cluster Mgmt via Pillar-driven Orchestration of Standalone Servers.
## Architecture
![](architecture.png?raw=true)

## Example
The point of SaltedJBoss is to be able to spec out a yaml outline (pillar) for all your clusters and have Salt use the pillar to configure and manage everything.
```yaml
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
    rsysloghost: 123.45.67.12
    nodes:
      clusternode01:
        portoffset: 500
      clusternode02:
        portoffset: 600
```
## Features
### JBoss Cluster
Management of JBoss clusters is the goal.   The difference is they are composed with standalone configuration rather than domain management or JBossON support.  
### A standalone configuration has some advantages over domain mgmt and JON-based mgmt:
* Deployment scanner support
* Ease of debugging
** Domain mgmt nodes are reportedly difficult to debug
* Simplicity and leveraging strengths of JBoss
* Dynamic compilation of JSPs to cluster 
