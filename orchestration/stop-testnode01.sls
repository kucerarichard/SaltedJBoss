stop-testnode01:
  salt.state.sls:
   - tgt: jboss-test1.zzzzz.zzzzz
   - sls: servernodes
   - pillar:
       overrides:
         testnode01:
           status: dead
