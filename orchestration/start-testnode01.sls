start-testnode01:
  salt.state.sls:
   - tgt: jboss-test1.zzzzz.zzzzz
   - sls: server.nodes
   - pillar:
       overrides:
         testnode01:
           status: running

