ProxySQL であそぼう
=

まずはイメージを用意します。以下のコマンドを打ってください。

```sh
docker-compose build
docker-compose pull
```

ProxySQL 単体を起動してみる
-

### このセクションにおける構成図

```
+----------+
| proxysql |
+----------+
```

まずは docker コンテナで proxysql を起動します。6032 は ProxySQL Admin インターフェイス, 6033 は MySQL 用のインターフェイス, 6080 は Webインターフェイス用です。

```sh
docker run --name proxysql --rm -p 6032:6032 -p 6033:6033 -p 6080:6080 sample-proxysql_proxysql
```

ログだけだとわびしいので、Webインターフェイスを覗いてみます。 http://localhost:6080 にアクセスし([BASIC認証は stats:stats](https://github.com/sysown/proxysql/wiki/Global-variables#admin-stats_credentials))、利用している ProxySQL や統計情報などを確認してみましょう。とはいえ、MySQL にはまだ接続していないので見どころはほぼ無いです。

```sh
mysql -uradmin -pradmin -h0.0.0.0 -P6032

# homebrew などで MySQL 8.0系が入っている場合は以下のコマンドを使う
mysql -uradmin -pradmin -h0.0.0.0 -P6032 --default-auth=mysql_native_password
```

```console
$ mysql -uradmin -pradmin -h0.0.0.0 -P6032 --default-auth=mysql_native_password
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 5.5.30 (ProxySQL Admin Module) ⭐⭐⭐

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SELECT version();
+--------------------+
| version()          |
+--------------------+
| 1.4.13-15-g69d4207 |
+--------------------+
1 row in set (0.01 sec)
```

ほかにも以下のようなコマンドを叩いてみると ProxySQL の情報を閲覧できます。

```sql
SELECT * FROM runtime_mysql_users;
SELECT * FROM runtime_mysql_servers;
```

ProxySQL 越しに MySQL へアクセスする
-

### このセクションにおける構成図

```
+--------+     +----------+     +--------+
| client | --> | proxysql | --> | mysqld |
+--------+     +----------+     +--------+
```

docker-compose を使って proxysql 越しに mysql へアクセスしてみましょう。今回のハンズオンでは、ホストから 0.0.0.0:6033 にアクセスすると proxysql 経由で mysql にアクセスできます。

```sh
docker-compose up -d

mysql -P6033 -h0.0.0.0 -uroot --default-character-set=utf8 --default-auth=mysql_native_password

# homebrew などで MySQL 8.0系が入っている場合は以下のコマンドを使う
mysql -P6033 -h0.0.0.0 -uroot --default-character-set=utf8 --default-auth=mysql_native_password
```

適当に SQL を叩いたあと、いったん mysql からログアウトしてください。

次に `mysql -uradmin -pradmin -h0.0.0.0 -P6032` などで ProxySQL admin interface にアクセスし、次のコマンドを叩いてみましょう。

```sql
SELECT * FROM runtime_mysql_users;
SELECT * FROM runtime_mysql_servers;

SELECT * FROM stats_mysql_connection_pool;
```

フェイルオーバサポート
-

たぶん時間ない

### このセクションにおける構成図

```
                                +----------+
                 +------------> | read db  |
                 |              +----------+
                 |                  | replication
+--------+     +----------+     +----------+
| client | --> | proxysql | --> | write db |
+--------+     +----------+     +----------+
                 |                  | replication
                 |              +----------+
                 +------------> | read db  |
                                +----------+
```

```sql
SET GLOBAL read_only=0;
SELECT * FROM runtime_mysql_servers;
```

Extra: ProxySQL Cluster
-

たぶん時間ない

### このセクションにおける構成図

```
                +----------+
            +-> | proxysql |----------+
            |   +----------+          |
            |        |                v
+--------+  |   +----------+     +----------+
| client | -+-> | proxysql | --> | write db |
+--------+  |   +----------+     +----------+
            |        |                ^
            |   +----------+          |
            +-> | proxysql | ---------+
                +----------+
```

```sql
SAVE PROXYSQL SERVERS TO DISK;
LOAD PROXYSQL SERVERS TO RUNTIME;
```
