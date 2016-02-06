drivers:
  com.h2database.h2:
    h2: 
      xa-datasource-class: org.h2.jdbcx.JdbcDataSource
  oracle.jdbc:
    oracle:
      xa-datasource-class: oracle.jdbc.xa.client.OracleXADataSource
    oracle-nonxa:
      datasource-class: oracle.jdbc.pool.OracleDataSource
  sqlserver.jdbc:
    sqlserver:
      xa-datasource-class: com.microsoft.sqlserver.jdbc.SQLServerDriver

