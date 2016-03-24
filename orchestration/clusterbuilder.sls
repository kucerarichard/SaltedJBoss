cluster_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: cluster.nodes

# cluster_control is targeted to the minion running on master
# and is instrumented on the salt master only.
# the miniontarget is the group of minions(hosts) that are 
# being used to scale out at the minion level, i.e. the
# actual cluster minions.  
cluster_control:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: cluster.control
    - pillar:
        miniontarget: 'jboss-test1.zzzzz.zzzzz'
    
launchdir_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deployment.launchdirs

reactor_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deployment.reactors

beacon_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deployment.beacons

balancer_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: cluster.balancers

loggernode_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: logger.nodes

loggerhost_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: logger.hosts

cmd.run:
  salt.function:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - arg:
       - echo 'Please restart salt if there are changes--service salt-master restart; service salt-minion restart'
