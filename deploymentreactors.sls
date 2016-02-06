/etc/salt/master.d/reactor.conf:
  file.managed:
    - source: salt://files/master.d/reactor.conf.jinja
    - template: jinja

