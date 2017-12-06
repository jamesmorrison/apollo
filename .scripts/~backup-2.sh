#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/vagrant/databases/$TIMESTAMP"

MYSQL_USER="root"
MYSQL_PASSWORD="root"
export MYSQL_PWD=$MYSQL_PASSWORD

mysql --user=$MYSQL_USER  -e 'show databases' | \
grep -v -F "information_schema" | \
grep -v -F "performance_schema" | \
grep -v -F "mysql" | \
grep -v -F "test" | \
grep -v -F "Database" | \
while read dbname; do mysqldump --force --opt --user=$MYSQL_USER --databases "$dbname" > "$BACKUP_DIR/$dbname.sql" && echo "Database $dbname backed up..."; done