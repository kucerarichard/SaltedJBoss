# Build out cluster specification from pillar/clusters.sls
# 
# How to uninstall/clean up cluster nodes:
# (if jboss starts to complain about running out of memory...)
# First, remove/reduce number of nodes in spec clusters.sls
# And then commit and push the pillar
# Then,
#   cd jboss-eap/bin
#   rm -f standalone-clusternode05.conf standalone-clusternode06.conf ...
#   chkconfig --del jboss-as-clusternode05.sh
#   chkconfig --del jboss-as-clusternode06.sh
#   chkconfig --del jboss-as-clusternode07.sh
#   chkconfig --del jboss-as-clusternode08.sh
#   cd /etc/init.d
#   rm -f jboss-as-clusternode05.sh jboss-as-clusternode06.sh ...
#   cd /var/log/jboss-as/
#   rm -f clusternode05-console.log clusternode06-console.log ...
#   cd /opt/logger.local/
#   rm -f jboss-prod1--prodcluster01--clusternode05-logger.sh jboss-prod1--...
#   cd /etc/jboss-as/
#   rm -f jboss-as-clusternode05.conf jboss-as-clusternode06.conf ...
# OR
#   just delete all your hosts and start over...

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
    
# install cluster deployment directory on launchdir minions.
# note: miniontarget is provided for manual deployment scripts 
#       to mitigate beacon failure.
launchdir_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deployment.launchdirs
    - pillar:
        miniontarget: 'jboss-test[1234]'

# install deployment reactors on master
reactor_setup:
  salt.state:
    - tgt: 'jboss-test1.zzzzz.zzzzz'
    - sls: deployment.reactors

# install deployment beacons on launchdir minions.
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
