#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/vagrant/databases/$TIMESTAMP"

MYSQL_USER="root"
MYSQL_PASSWORD="root"
export MYSQL_PWD=$MYSQL_PASSWORD
 
mkdir -p "$BACKUP_DIR"

databases=`mysql --user=$MYSQL_USER -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|phpmyadmin|sys|mysql)"`
 
for db in $databases; do
  mysqldump --force --opt --user=$MYSQL_USER --databases $db > "$BACKUP_DIR/$db.sql"
done