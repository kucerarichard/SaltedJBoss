/etc/rsyslog.d/jboss-salted.conf:
  file.managed:
    - source: salt://files/rsyslog/logsplitter.conf.jinja
    - template: jinja

/var/log/jboss-salted:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - recurse:
        - user
        - group
        - mode
