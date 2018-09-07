FROM debian:9

RUN apt-get -qq update \
      && apt-get install -qq -y --no-install-recommends lsb-release wget gnupg \
      && wget -qO- 'http://repo.mysql.com/RPM-GPG-KEY-mysql' | apt-key add - \
      && echo 'deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7' > /etc/apt/sources.list.d/mysql.list \
      &&{ \
        echo mysql-community-server mysql-community-server/data-dir select ''; \
          echo mysql-community-server mysql-community-server/root-pass password ''; \
          echo mysql-community-server mysql-community-server/re-root-pass password ''; \
          echo mysql-community-server mysql-community-server/remove-test-db select false; \
      } | debconf-set-selections \
      && wget -qO- 'http://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add - \
      && echo deb http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/$(lsb_release -sc)/ ./ | tee /etc/apt/sources.list.d/proxysql.list \
      && apt-get -qq update && apt-get install -qq -y --no-install-recommends proxysql=1.4.10 mysql-client=5.7.23-1debian9 \
      && mkdir /var/log/proxysql \
      && rm -r /var/lib/apt/lists/*

COPY mylogin.cnf /root/.mylogin.cnf
COPY proxysql.cnf /etc/proxysql.cnf
CMD ["proxysql", "-f"]
