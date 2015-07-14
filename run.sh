#!/bin/bash

echo
echo "Setting up MySql database ..."

BIB_MYSQL_PASSWORD_EXPR="-p$BIB_MYSQL_PASSWORD"

if [ "$BIB_USE_EXT_MYSQL" = "no" ]; then
  /usr/bin/mysqld_safe > /dev/null 2>&1 &
  RET=1
  while [[ RET -ne 0 ]]; do
      echo -n "."
      sleep 5
      mysql -uroot -e "status" > /dev/null 2>&1
      RET=$?
  done
  
  BIB_MYSQL_PASSWORD_EXPR=""
fi

mysql -u$BIB_MYSQL_USER $BIB_MYSQL_PASSWORD_EXPR -e "CREATE USER 'bibliograph'@'%' IDENTIFIED BY 'bibliograph';"
mysql -u$BIB_MYSQL_USER $BIB_MYSQL_PASSWORD_EXPR -e "GRANT ALL PRIVILEGES ON *.* TO 'bibliograph'@'%' WITH GRANT OPTION;"
mysql -u$BIB_MYSQL_USER $BIB_MYSQL_PASSWORD_EXPR -e "CREATE DATABASE bibliograph_admin;"
mysql -u$BIB_MYSQL_USER $BIB_MYSQL_PASSWORD_EXPR -e "CREATE DATABASE bibliograph_user;"
mysql -u$BIB_MYSQL_USER $BIB_MYSQL_PASSWORD_EXPR -e "CREATE DATABASE bibliograph_tmp;"

if [ "$BIB_USE_EXT_MYSQL" = "no" ]; then
  mysqladmin -uroot shutdown
fi

echo
echo "Server ready." 

exec supervisord -n

