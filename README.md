## Connect to admin remotely

- ProxySQL admin port: 6032

NOTE: the default `admin` user CAN NOT connect remotely, so you'd connect remotely as a secondary user `radmin`: `mysql -uradmin -pradmin -h0.0.0.0 -P6032`

See details: https://github.com/sysown/proxysql/wiki/Global-variables#admin-admin_credentials

## See ProxySQL statistics on Web UI

1. Run `docker-compose up`
1. Access to http://0.0.0.0:6088 .
1. Input `stats:stats` into BASIC auth to login.

See details: https://github.com/sysown/proxysql/wiki/HTTP-Web-Server
