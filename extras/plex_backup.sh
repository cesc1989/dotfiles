#!/usr/bin/env bash
#
# Ejecutar: sudo ./plex_backup.sh
#
# Sino tiene permisos: chmod a+x ./plex_backup.sh

systemctl stop plexmediaserver.service

PLEX='/var/lib/plexmediaserver/Library/Application Support/Plex Media Server'
EXCLUDES=(
  --exclude="$PLEX/Diagnostics"
  --exclude="$PLEX/Logs"
  --exclude="$PLEX/Updates"
  --exclude="$PLEX/Crash Reports"
  --exclude="$PLEX/Cache"
  --exclude="$PLEX/Codecs"
  --exclude="$PLEX/Plug-in Support/Caches"
)

tar -cjpvf /media/cesc/plexmediaserver_$(date +%Y-%-m-%d_%H-%M-%S).tar.bz2 \
    "${EXCLUDES[@]}" /var/lib/plexmediaserver

systemctl start plexmediaserver.service
