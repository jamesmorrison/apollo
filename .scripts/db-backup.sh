#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/vagrant/databases/$TIMESTAMP"

MYSQL_USER="root"
MYSQL_PASSWORD="root"
export MYSQL_PWD=$MYSQL_PASSWORD
 
mkdir -p "$BACKUP_DIR"

databases=`mysql --user=$MYSQL_USER -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|sys|mysql)"`

echo "Backing up your databases; this can take a few minutes..."

if [ ! -z "$databases" ]; then

	for db in $databases; do
		mysqldump --force --opt --user=$MYSQL_USER --databases $db > "$BACKUP_DIR/$db.sql"
		echo "Database $db backed up..."
	done

	if [ -d "$BACKUP_DIR" ] && [ "$(ls -A $BACKUP_DIR)" ]; then

		echo "Compressing databases..."

		zip -r "$BACKUP_DIR.zip" "$BACKUP_DIR"

		echo "Databases have been backed up and compressed to $TIMESTAMP.zip"

		rm -R "$BACKUP_DIR"

		echo "Database folder ($TIMESTAMP) has been removed."

	else

		echo "No databases were found; no backup was created."

	fi

fi
