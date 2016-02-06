stop-testcluster01:
  salt.state.sls:
   - tgt: jboss-test1.zzzzz.zzzzz
   - sls: clusternodes
   - pillar:
       overrides:
         testcluster01:
           status: dead
