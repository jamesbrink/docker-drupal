#!/bin/bash
# Basic health check script to ensure MySQL is available

MAX_COUNT=$((5))
COUNTER=$((0))

function test_mysql()
{
  echo "Attempting connection"
  mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" &> /dev/null
  return $?
}
until test_mysql [ $? -eq 0  ]
do
  echo "Sleeping for MySQL Host: ${MYSQL_HOST} on port: ${MYSQL_PORT}"
  sleep 5
  ((COUNTER+=1))
  if [ $COUNTER -eq $MAX_COUNT ]; then
    echo "Giving up on waiting for MySQL Host"
    exit 1
  fi
done
echo "MySQL Host is ready!"
