#!/bin/bash

# Configuration de base
DATE=$(date +"%Y-%m-%d")
HOUR=$(date +"%H%p")

# Dossier où se trouve mes domaines
DOMAINS_FOLDER="/apps"

# Dossier où sauvegarder les backups (créez le d'abord!)
BACKUP_DIR="/home/backup/domains"

# Nombre de jours à garder les dossiers (seront effacés après X jours)
RETENTION=2

# Create a new directory into backup directory location for this date
mkdir -p $BACKUP_DIR/$DATE/$HOUR

# Backup domains
for folder in $(find ${DOMAINS_FOLDER} -mindepth 1 -maxdepth 1 -type d)
do
        cd $(dirname ${folder})
        tar czpf ${BACKUP_DIR}/$DATE/$HOUR/$(basename ${folder}).tar.gz $(basename ${folder})
        cd - > /dev/null
done

# Remove files older than X days
find $BACKUP_DIR -maxdepth 1 -mtime +$RETENTION -exec rm -rf {} \;

# Sync Mega Cloud
mega-sync -dsr /home/backup backup
