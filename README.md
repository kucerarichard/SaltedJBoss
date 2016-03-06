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
```
## Features

### JBoss Cluster
Management of JBoss clusters is the goal.   The difference is they are composed with standalone configuration rather than domain management or JBossON support.  

#### A standalone configuration has some advantages over domain mgmt and JON-based mgmt:
* Deployment scanner support
* Ease of debugging
* Simplicity and leveraging strengths of JBoss
* Dynamic compilation of JSPs to cluster 
* Ergonomically feasible/programmable deployment of large, independently managed clusters on many hosts/containers with multiple JVMs on each host/container(if desired)

#### File-based configuration vs Salt JBoss7 Modules
* State and Execution modules for JBoss are available in saltstack.
* The JBoss7 Execution module is incorporated in SaltedJBoss
* The JBoss7 State modules are not currently used.
* JBoss has excellent support for file-based configuration so it is not necessary,  or even possible,  to channel all the config needed to build a cluster through the CLI.
* This gives external management systems such as salt great access to JBoss for building servers.
* The jboss7 and jboss7_cli execution modules are used for convenient functions such as "reload" the CLI functions are called from a generated command script which calls all the minions which form the cluster with the command.
* The script uses a salt-call approach (remote execution of jboss7 module as a command directly on the minion) in order to be able to pass dynamic parameters to the command while on the master (that would otherwise be more cumbersome with a state file).
```bash
[root@jboss-test1 bin]# ./command-testcluster01.sh
jboss-test1.xxxxx.xxxxx:
    usage: command-testcluster01.sh <module.command> [args]
    e.g. ./command-testcluster01.sh jboss7.list_deployments
    e.g. ./command-testcluster01.sh jboss7.reload
    e.g. ./command-testcluster01.sh jboss7.status
    e.g. ./command-testcluster01.sh jboss7.stop_server
    e.g. ./command-testcluster01.sh jboss7.read_datasource [name]
    e.g. ./command-testcluster01.sh jboss7.read_simple_binding [name]
    e.g. ./command-testcluster01.sh jboss7_cli.run_command 'help --commands'
```

## Notes

* When adding a member to the balancer
** The cluster needs to be restarted to "let go" of the multicast group in order to accept a new httpd balancer advertizer (to join the cluster)
** eventually the receiver stops recording all advertizer balancer pings on other hosts,  but they all remain joined on cluster
*** this could mean there is a period of cluster registration at startup time that ends
*** have to test that theory
** this should not affect the backend jbosses joining an existing cluster of httpd advertizers
*** seems to only affect the advertizers on the balancer side
