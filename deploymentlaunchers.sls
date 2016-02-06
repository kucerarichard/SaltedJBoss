{# deploy exploded directory or archive:
 # 1. rsync
 # 2. change ownership/perms
 # 3. dodeploy option
 #}

{% macro do_set_deploy_cmds(nodename,nodeprops) -%}

{%     set nodedeployedto = nodeprops %}
{%     set launchdir = nodedeployedto['launchdir'] %}

{%     set rsync_master =  nodedeployedto['launchhost'] %}
{%     set deploy_src_prefix = launchdir+'/' %}
{%     set deploy_tgt_prefix = nodedeployedto['jbosshome']+'/'+nodename+'/deployments' %}

{%     if deploy_src_path.endswith('.dodeploy') %}

{%       set rsync_recurse = '/' %}
{%       set deploy_tgt_path = deploy_tgt_prefix+'/'+deploy_src_path.split(deploy_src_prefix,1)[1] %}
{%       set dodeploy_cmd = 'touch '+deploy_tgt_path %}

{%     elif salt['file.directory_exists'](deploy_src_path) %}

{%       set rsync_recurse = '/' %}
{%       set dodeploy_cmd = '' %}

{%     elif deploy_src_path.endswith('.jsp') %}

{%       set rsync_recurse = '' %}
{%       set dodeploy_cmd = '' %}

{%     elif deploy_src_path.endswith('.war') %}

{%       set rsync_recurse = '' %}
{%       set dodeploy_cmd = '' %}

{%     endif %}

{%     set deploy_tgt_path = deploy_tgt_prefix+'/'+deploy_src_realpath.split(deploy_src_prefix,1)[1] %}

{%     set rsync_cmd = '/usr/bin/rsync -avH '+rsync_master+':'+deploy_src_realpath+rsync_recurse+' '+deploy_tgt_path %}
{%     set chown_cmd = 'chown -R jboss:jboss '+deploy_tgt_path %}

{%     if deploy_cmds.append( rsync_cmd ) %}{% endif %}
{%     if deploy_cmds.append( chown_cmd ) %}{% endif %}
{%     if deploy_cmds.append( dodeploy_cmd ) %}{% endif %}
{%- endmacro %}

{% set deploy_cmds = [] %}

{% set deploy_src_path = pillar['deploy_src_path'] %}

{% if deploy_src_path.endswith('.dodeploy') %}
{%    set deploy_src_realpath = deploy_src_path.split('.dodeploy',1)[0] %}
{% else %}
{%    set deploy_src_realpath = deploy_src_path %}
{% endif %}

{# Get the app name #}
{% set deploymentname = deploy_src_realpath.split('/')[-1] %}

{# Get the cluster or node this app belongs to #}
{% set deploymentprops = salt['pillar.get']('deployments')[ deploymentname ] %}

{# Validate the deployment format #}
{% if deploymentprops['format'] != 'archive' and
      deploymentprops['format'] != 'exploded' %}
{{    'Invalid deployment format:'+deploymentprops['format'] }}
{% endif %}

{% if deploymentprops['cluster'] is defined %}
{%     set clusterdeployedto = salt['pillar.get']('clusters')[ deploymentprops['cluster'] ] %}
{%     set launchdir = clusterdeployedto['launchdir'] %}
{%     for instname, instprops in clusterdeployedto['nodes'].iteritems() %}
{{       do_set_deploy_cmds( instname, clusterdeployedto ) }}
deploy_{{ deploymentname }}_{{ instname }}:
  cmd.run:
    - name: su jboss -c "{{ deploy_cmds[-3] }}; {{ deploy_cmds[-2] }}; {{ deploy_cmds[-1] }}"
{%     endfor %}
{% else %}
{%     set nodedeployedto = salt['pillar.get']('nodes')[ deploymentprops['node'] ] %}
{{     do_set_deploy_cmds(  deploymentprops['node'], nodedeployedto ) }}
deploy_{{ deploymentname }}_{{ deploymentprops['node'] }}:
  cmd.run:
    - name: su jboss -c "{{ deploy_cmds[-3] }}; {{ deploy_cmds[-2] }}; {{ deploy_cmds[-1] }}"
{% endif %}

