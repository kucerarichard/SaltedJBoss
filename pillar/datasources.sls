datasources:
  SomeDS: 
    jndi-name: java:/SomeDS
    enabled: 'true'
    connection-url: jdbc:oracle:thin:user/pass@somedb.zzzz.zzzz:1521:SOMETHING
    driver: oracle
    driver-class: oracle.jdbc.OracleDriver
    connection-properties:
      'v$session.program': Something
    min-pool-size: 1
    max-pool-size: 5
    username: user
    password: pass
  AnotherDS:
    jndi-name: java:/ANOTHERDS
    enabled: 'true'
    connection-url: jdbc:sqlserver://SOMEHOST.zzzzz.zzzzz:1433;databaseName=SomethingElse
    driver: sqlserver
    driver-class: com.microsoft.sqlserver.jdbc.SQLServerDriver
    min-pool-size: 1
    max-pool-size: 5
    username: user
    password: pass
