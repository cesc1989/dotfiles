#!/usr/bin/env bash
#
# Ejecutar: sudo ./plex_backup.sh
#
# Sino tiene permisos: chmod a+x ./plex_backup.sh

systemctl stop plexmediaserver.service

PLEX='/var/lib/plexmediaserver/Library/Application Support/Plex Media Server'

tar -cjpvf /media/cesc/plexmediaserver_$(date +%Y-%-m-%d_%H-%M-%S).tar.bz2 \
    --exclude '$PLEX/Diagnostics' \
    --exclude '$PLEX/Logs' \
    --exclude '$PLEX/Updates' \
    --exclude '$PLEX/Crash Reports' \
    --exclude '/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache' \
    /var/lib/plexmediaserver

systemctl start plexmediaserver.service
