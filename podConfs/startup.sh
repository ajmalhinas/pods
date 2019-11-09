#!/bin/bash

# this script is intended to be called from .bashrc
# This is a workaround for not having something like supervisord

if [ ! -e /var/run/mysqld/gitpod-init.lock ]
then
    touch /var/run/mysqld/gitpod-init.lock

    # initialize database structures on disk, if needed
    [ ! -d /workspace/mysql ] && mysqld --initialize-insecure

    # launch database, if not running
    [ ! -e /var/run/mysqld/mysqld.pid ] && mysqld --daemonize --log-error

    rm /var/run/mysqld/gitpod-init.lock
fi
#service apache2 restart  #not working due to environment variables are not drived
apachectl start
mysql<$GITPOD_REPO_ROOT/podConfs/mysqlInit.sql
$CATALINA_BASE/bin/startup.sh
