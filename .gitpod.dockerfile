
FROM ubuntu:18.04
#FROM gitpod/workspace-full

#prevent interactive promts when installation
ENV DEBIAN_FRONTEND=noninteractive
#workaround for unavailability of $GITPOD_REPO_ROOT
ARG REPO_ROOT=/workspace/pods/

ARG JDK_PATH=/usr/lib/java11dcevm
ARG TOMCAT_PATH=/usr/local/
ENV CATALINA_BASE=$TOMCAT_PATH/tomcat
ARG JDK_URL=https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases/download/dcevm-11.0.1%2B8/java11-openjdk-dcevm-linux.tar.gz
ARG TOMCAT_URL=https://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.27/bin/apache-tomcat-9.0.27.tar.gz
ENV PATH=$PATH:$JDK_PATH/bin
ENV JAVA_HOME=/usr/lib/java11dcevm

USER root

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc


RUN apt-get update && apt-get -y install wget mysql-server apache2 phpmyadmin \
 && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* \
 && mkdir /var/run/mysqld \
 && chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade \
 #removes default data (user) files which prevents login to non root
 && rm -r /var/lib/mysql/* \
 && chown -R gitpod:gitpod /var/www /var/run/apache2 /var/lock/apache2  /var/log/apache2 \
 && ln -s  /usr/share/phpmyadmin  /var/www/html/phpmyadmin \
 && echo "include $REPO_ROOT/podConfs/apache/apache.conf" > /etc/apache2/apache2.conf \
 && echo ". $REPO_ROOT/podConfs/apache/envvars" > /etc/apache2/envvars \
 && echo "!include $REPO_ROOT/podConfs/mysql/mysql.cnf" > /etc/mysql/my.cnf

#install dcevm and tomcat
 RUN  mkdir $JDK_PATH \
 && cd $JDK_PATH \
 && wget $JDK_URL \
 && tar xf java11-openjdk-dcevm-linux.tar.gz \
 && cd dcevm-11.0.1+8/  \
 && mv * ../  \
 && cd ..  \
 && rm -r dcevm-11.0.1+8/  \
 && rm java11-openjdk-dcevm-linux.tar.gz \
 && cd  $TOMCAT_PATH \
 && wget $TOMCAT_URL \
 && tar xf apache-tomcat-9.0.27.tar.gz \
 && mv apache-tomcat-9.0.27 tomcat  \
 && rm apache-tomcat-9.0.27.tar.gz  \
 && chown -R gitpod:gitpod $CATALINA_BASE





#USER gitpod  This operation is perfomed by gitpod layer. So not needed.






