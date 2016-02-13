cluster_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: clusternodes

cluster_control:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: clustercontrol
    - pillar:
        miniontarget: 'jboss-test1.zzzzz.zzzzz'
    
launchdir_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deploymentlaunchdirs

reactor_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deploymentreactors

beacon_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deploymentbeacons

balancer_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: clusterbalancers

loggernode_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: loggernodes

loggerhost_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: loggerhosts

cmd.run:
  salt.function:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - arg:
       - echo 'Please restart salt if there are changes--service salt-master restart; service salt-minion restart'
