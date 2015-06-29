#!/bin/bash

# create databases
echo "Setting up databases ..."

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

mysql -uroot -e "CREATE USER 'bibliograph'@'%' IDENTIFIED BY 'bibliograph';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'bibliograph'@'%' WITH GRANT OPTION;"
mysql -uroot -e "CREATE DATABASE bibliograph_admin;"
mysql -uroot -e "CREATE DATABASE bibliograph_user;"
mysql -uroot -e "CREATE DATABASE bibliograph_tmp;"

mysqladmin -uroot shutdown

echo "Bibliograph server ready." 

exec supervisord -n

