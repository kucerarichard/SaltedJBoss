start-testcluster01:
  salt.state.sls:
   - tgt: jboss-test1.zzzzz.zzzzz
   - sls: cluster.nodes
   - pillar:
       overrides:
         testcluster01:
           status: running

