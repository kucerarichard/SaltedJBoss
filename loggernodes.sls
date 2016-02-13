{#
 #
 # SUMMARY
 # Centralize logging of all cluster and server nodes.
 # provide simple targeted logging, outside of server xml config.
 # (default syslog config is also done in server xml config
 #  and sent to rsysloghost,  there may be overlap but the
 #  logger config can be more agile and targeted).
 #
 # RUNNING
 # rudimentary logger process control.
 #
 # example use salt to start all loggers:
 #
 #  salt jboss-test1.* cmd.run "bash -c 'cd /opt/logger.local; for i in \$(ls); do ./\$i; done'"
 #
 # example start specific logger on all targeted minions:
 #
 #  salt jboss-test1.* cmd.run "/opt/logger.local/some-logger.sh"
 #
 # example use salt to kill all loggers on targeted minions:
 #
 #  salt jboss-test1.* cmd.run "pkill tail"
 #    or
 #  salt jboss-test1.* ps.pkill tail
 #
 # logger will be tagged with cluster or node name.
 # loggers is different than the overall syslog setup
 # and can target very specific things in an
 # ad hoc way without changing the overall syslog
 # config, depending on the unix filter pipes setup
 # in the logger script.
 #
 # target log file is the standard /var/log/jboss-as location
 # in a file defined/enabled in jinja file:
 #   files/jboss-as-standalone.sh.jinja  
 #
 # catchall facilities
 # local0 == messages end up in other.log
 # local3 == messages end up in logger.log
 #}

{% from 'lib/loggerlib.sls' import logger with context %}

{% for clustername, clusterprops in salt['pillar.get']('clusters', {}).iteritems() %}

{%   for instname, instprops in clusterprops['nodes'].iteritems() %}

{% set minionid = grains['id'] %}

{{ logger('/var/log/jboss-as/'+instname+'-console.log','local3','info',minionid+'--'+clustername+'--'+instname) }}

{%   endfor %}
{% endfor %}

{% for instname, instprops in salt['pillar.get']('nodes', {}).iteritems() %}

{% set minionid = grains['id'] %}

{{ logger('/var/log/jboss-as/'+instname+'-console.log','local3','info',minionid+'--'+instname) }}

{% endfor %}
