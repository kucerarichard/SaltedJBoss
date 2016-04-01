/etc/salt/minion.d/beacon.conf:
  file.managed:
    - source: salt://files/minion.d/beacon.conf.jinja
    - template: jinja
    - makedirs: True

