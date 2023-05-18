# SaltedJBoss
SaltStack-based JBoss Cluster Mgmt via Pillar-driven Orchestration of Standalone Servers.

Example of Predictive Orchestration with Salt (a.k.a. glue).

Not sure if this thing crosses the line between the "clever use of tools" and Craptacular Command Framework.  Whatever is there is written in bash,  not javascript nor java, nor python.  It's not a command runner in Ahoy or Just or Make.  It's salt commands and templates,  which are tools,  which I learned and got some fluency in,  so,  no I don't think it crossed that line,  but other lines were crossed like perhaps it's somewhat overkill depending on your requirements.

The example also demonstrates how the salt pillar achieves with simple templating what kubernetes could not (see helm vs kustomize etc).

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

## Setup hosts/containers, salt master/minions and eap/wildfly

Prerequisites.  You need to manually install the following:
* Provision hosts/containers.  Decide how coarse-grained the hosts depending on requirements or other factors.
  * The cluster will scale out both within the host (to consume RAM with multiple JVMs) and along the minion axis (multiple jboss hosts)
  * You can put multiple Salt minions on a host provided you can get them working with their own IDs and own /etc/salt/minion directory, and test that they don't interfere with each other's operation.  Each minion can then shadow a cluster or group of clusters (each minion would get its own pillar data).  The cluster.sls file can already accomodate multiple clusters and can be managed with one minion.  Multiple minions on the same host is just yet another config option,  that would be best to manage with salt itself (a main host minion would manage the per-service minions).  But,  don't do this.
* Install Salt Master/Minions
  * Put a minion on every JBoss host
  * Put a minion on the salt master.
  * Put a minion on the optional launch host (or put launch host on the salt master)
    * it's a good practice to put launch host on salt master because the
	manual failsafe (do-deploy.sh scripts for each app deployment) for the failure 
	of salt beacon/reactor system depends on being on salt master.
* Install EAP 6.4 or Wildfly on all minions (hosts/containers)
* RHQ/JBossON.  Auto-discover and manage all your nodes after they're built out with Salt.  Two ways to manage things is a good idea.  Different tools have different strengths/weaknesses and in case of failure of beacon system or your production python installation gets hosed,  or RHQ cassandra internals gets messed up or you lose all your agents for some reason (a rather sinking feeling).
 
## Build a cluster

* To Do

## Query a cluster

* Two ways to find out what datasources are deployed and where
   * a summary for each minion 
```
# command-testcluster01.sh jboss7_cli.run_command '/subsystem=datasources:read-resource'
... many minions report back...
{
    "outcome" => "success",
    "result" => {
        "xa-data-source" => undefined,
        "data-source" => {
            "ExampleDS" => undefined,
            "MySQLPool" => undefined
        },
        "jdbc-driver" => {
            "h2" => undefined,
            "mysql" => undefined
        }
    }
}
```
   * specific detail for every datasource
```
# for i in `salt-call pillar.keys datasources | grep '-' | sed 's/-//'`; do command-testcluster01.sh jboss7.read_datasource $i; done
... many minions report back ...
            url-delimiter:
                None
            url-selector-strategy-class-name:
                None
            use-ccm:
                True
            use-fast-fail:
                False
            use-java-context:
                True
            use-try-lock:
                None
            user-name:
                mydatasource
            valid-connection-checker-class-name:
                None
            valid-connection-checker-properties:
                None
            validate-on-match:
                False
        success:
            True
... a lot of detail ... later use jobs.lookup_jid | less to review
```

## Dynamic Pillars
 
It should be possible to add flexibility in the Pillar by writing code in it:

``` 
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
{% if grain == dev or whatever %}
    jspconfig:
      dev: 'true'
      checkinterval: 5
{% endif %}
    launchhost: jboss-test1.zzzzz.zzzzz
    launchdir: /usr/local/testcluster01-deployments
    launchhandler: jboss-deploy.sls
    jbosshome: /usr/local/jboss-eap-6.4
    nodes:
{% for 10 .. 30 %}
      clusternode{{ i }}:
        portoffset: {{ i }}00
{% endfor %}
```

## Notes

* When adding a member to the balancer
  * The cluster needs to be restarted to "let go" of the multicast group in order to accept a new httpd balancer advertizer (to join the cluster)
  * eventually the receiver stops recording all advertizer balancer pings on other hosts,  but they all remain joined on cluster
     * this could mean there is a period of cluster registration at startup time that ends. have to test that theory
  * this should not affect the backend jbosses joining an existing cluster of httpd advertizers
     * seems to only affect the advertizers on the balancer side
