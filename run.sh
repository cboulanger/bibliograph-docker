#!/bin/bash

echo
echo "Setting up MySql database ..."

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo -n "."
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

echo
echo "Server ready." 

exec supervisord -n

