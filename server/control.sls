{{ jbosshome }}/bin/start-{{ nodename }}.sh:
  file.managed:
    - source: salt://files/scripts/start-nodes.sh.jinja
    - template: jinja
    - user: jboss
    - group: jboss
    - mode: 755
    - defaults:
        entityname: {{ nodename }}

{{ jbosshome }}/bin/stop-{{ nodename }}.sh:
  file.managed:
    - source: salt://files/scripts/stop-nodes.sh.jinja
    - template: jinja
    - user: jboss
    - group: jboss
    - mode: 755
    - defaults:
        entityname: {{ nodename }}

/srv/salt/orchestration/start-{{ nodename }}.sls:
  file.managed:
    - source: salt://files/scripts/start-nodes.sls.jinja
    - template: jinja
    - mode: 755
    - defaults:
        entityname: {{ nodename }}
        miniontarget: {{ miniontarget }}
        entitysls: server.nodes

/srv/salt/orchestration/stop-{{ nodename }}.sls:
  file.managed:
    - source: salt://files/scripts/stop-nodes.sls.jinja
    - template: jinja
    - mode: 755
    - defaults:
        entityname: {{ nodename }}
        miniontarget: {{ miniontarget }}
        entitysls: server.nodes

