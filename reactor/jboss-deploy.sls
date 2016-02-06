{% if data['data']['path'].endswith('.dodeploy') or
      salt['file.directory_exists'](data['data']['path']) or
      data['data']['path'].endswith('.jsp') or
      data['data']['path'].endswith('.war') %}

{# run the rsync on the minion #}

deploy_app:
  local.state.sls:
   - tgt: jboss-test1.xxxxx.xxxxx
   - arg:
      - deploymentlaunchers
   - kwarg:
       pillar:
         deploy_src_path: {{ data['data']['path'] }} 

{% else %}

{# ignore event.
 # the attrib is the mask so there shouldn't be too many events
 # these would be temp file events when a file was edited in place
 # for example.
      - pillar="{ deploy_src_path: '{{ data['data']['path'] }}' }"
      - pillar='{"deploy_src_path": "{{ data['data']['path'] }}"}'
      - pillar='{ deploy_src_path: {{ data['data']['path'] }} }'
 #}

{% endif %}

