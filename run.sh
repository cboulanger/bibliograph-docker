#!/bin/bash

echo
echo "Setting up MySql database ..."
CLIENT_IP=$(hostname --ip-address)

# use the container mysql server
if [ "$BIB_USE_HOST_MYSQL" = "no" ]; then
  /usr/bin/mysqld_safe > /dev/null 2>&1 &
  RET=1
  while [[ RET -ne 0 ]]; do
      echo -n "."
      sleep 5
      mysql -uroot -e "status" > /dev/null 2>&1
      RET=$?
  done
  AUTH_ARGS="-u$BIB_MYSQL_USER"
fi

# use the host mysql server
if [ "$BIB_USE_HOST_MYSQL" = "yes" ]; then
  HOST_IP=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
  echo "Accessing MySql Server on $HOST_IP from $CLIENT_IP"
  sed -i.bak "s/0\.0\.0\.0/$HOST_IP/" $BIB_CONF_DIR/bibliograph.ini.php
  AUTH_ARGS="-u$BIB_MYSQL_USER -p$BIB_MYSQL_PASSWORD -h$HOST_IP"
fi

mysql $AUTH_ARGS -e "CREATE DATABASE IF NOT EXISTS bibliograph_admin;"
mysql $AUTH_ARGS -e "CREATE DATABASE IF NOT EXISTS bibliograph_user;"
mysql $AUTH_ARGS -e "CREATE DATABASE IF NOT EXISTS bibliograph_tmp;"
mysql $AUTH_ARGS -e "GRANT ALL PRIVILEGES ON \`bibliograph\_%\`.* TO 'bibliograph'@'$CLIENT_IP' IDENTIFIED BY 'bibliograph' WITH GRANT OPTION;"

if [ "$BIB_USE_HOST_MYSQL" = "no" ]; then
  mysqladmin -uroot shutdown
fi

echo
echo "Server ready." 

exec supervisord -n

