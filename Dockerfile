FROM debian:9

RUN apt-get -qq update && apt-get install -qq -y --no-install-recommends lsb-release wget gnupg
RUN wget -O- 'http://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add -
RUN echo deb http://repo.proxysql.com/ProxySQL/proxysql-1.4.x/$(lsb_release -sc)/ ./ | tee /etc/apt/sources.list.d/proxysql.list
RUN apt-get -qq update && apt-get install -qq -y --no-install-recommends proxysql=1.4.8
COPY proxysql.cnf /etc/proxysql.cnf
CMD ["proxysql", "-f"]
