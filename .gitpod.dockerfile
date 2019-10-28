
FROM gitpod/workspace-full

#prevent interactive promts when installation
ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get -y install mysql-server apache2 phpmyadmin \
 && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* \
 && mkdir /var/run/mysqld \
 && chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade \
 #removes default data (user) files which prevents login to non root
 && rm -r /var/lib/mysql/* \
 && chown -R gitpod:gitpod /var/www /var/run/apache2 /var/lock/apache2 \
 && ln -s  /usr/share/phpmyadmin  /var/www/html/phpmyadmin \
 && echo "include /workspace/pods/podConfs/apache/apache.conf" > /etc/apache2/apache2.conf \
 && echo ". /workspace/pods/podConfs/apache/envvars" > /etc/apache2/envvars \
 && echo "!include /workspace/pods/podConfs/mysql/mysql.cnf" > /etc/mysql/my.cnf








