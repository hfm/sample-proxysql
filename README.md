# ProxySQL sandbox

## Access MySQL through ProxySQL

1. Run `docker-compose up`
1. `mysql -uroot -h0.0.0.0 -P6033`

```sql
$ mysql -uroot -h0.0.0.0 -P6033
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 28
Server version: 5.5.30 (ProxySQL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| backend            |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```

## Connect to admin remotely

- ProxySQL admin port: 6032

NOTE: the default `admin` user CAN NOT connect remotely, so you'd connect remotely as a secondary user `radmin`: `mysql -uradmin -pradmin -h0.0.0.0 -P6032`

See details: https://github.com/sysown/proxysql/wiki/Global-variables#admin-admin_credentials

## See ProxySQL statistics on Web UI

1. Run `docker-compose up`
1. Access to http://0.0.0.0:6088 .
1. Input `stats:stats` into BASIC auth to login.

See details: https://github.com/sysown/proxysql/wiki/HTTP-Web-Server
