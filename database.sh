#!/bin/bash

# Configuration de base
DATE=$(date +"%Y-%m-%d")
HOUR=$(date +"%H%p")

# Dossier où sauvegarder les backups (créez le d'abord!)
BACKUP_DIR="/home/backup/databases"

# Identifiants MySQL
MYSQL_USER=""
MYSQL_PASSWORD=""

# Commandes MySQL (aucune raison de modifier ceci)
MYSQL=/mysql/bin/mysql
MYSQLDUMP=/mysql/bin/mysqldump

# Bases de données MySQL à ignorer
SKIPDATABASES="Database|information_schema|performance_schema|mysql"

# Nombre de jours durant lesquelles on garde les dossiers (seront effacés après X jours)
RETENTION=3

# Create a new directory into backup directory location for this date
mkdir -p $BACKUP_DIR/$DATE/$HOUR

# Retrieve a list of all databases
databases=`$MYSQL -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "($SKIPDATABASES)"`

# Dumb the databases in seperate names and gzip the .sql file
for db in $databases; do
echo $db
$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --skip-lock-tables --events --databases $db | gzip > "$BACKUP_DIR/$DATE/$HOUR/$db.sql.gz"
done

# Remove files older than X days
find $BACKUP_DIR -maxdepth 1 -mtime +$RETENTION -exec rm -rf {} \;

# Sync Mega Cloud
mega-sync -dsr /home/backup backup
