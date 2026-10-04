#!/usr/bin/env bash
#
# backup.sh - Respaldo de Documentos y Plex Media Server
#
# Subcomandos:
#   docs    Respalda ~/Documentos/Documentos en un archivo .7z
#   plex    Respalda Plex Media Server en un .tar.bz2 (requiere root)
#   all     Ejecuta ambos (continua con Plex aunque falle Documentos)
#
# Flags:
#   --dry-run        Muestra lo que haria, sin crear ni borrar nada
#   --no-cloud       No sube a la nube
#   --no-drive       No usa el disco externo (util para pruebas)
#   --verbose, -v    Salida detallada
#   --config FILE    Archivo de configuracion alternativo
#   --help, -h       Muestra esta ayuda
#
# Ejemplos:
#   sudo -E ./backup.sh all
#   ./backup.sh docs --no-drive
#   ./backup.sh docs --dry-run
#
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_NAME="$(basename "$0")"

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------
SUBCOMMAND=""
DRY_RUN=0
NO_CLOUD=0
NO_DRIVE=0
VERBOSE=0
CONFIG_FILE=""

usage() {
  cat <<'EOF'
Uso: backup.sh {docs|plex|all} [opciones]

Subcomandos:
  docs    Respalda ~/Documentos/Documentos en un .7z
  plex    Respalda Plex Media Server en un .tar.bz2 (requiere root)
  all     Ejecuta ambos

Opciones:
  --dry-run        Muestra lo que haria, sin crear ni borrar nada
  --no-cloud       No sube a la nube
  --no-drive       No usa el disco externo (util para pruebas)
  --verbose, -v    Salida detallada
  --config FILE    Archivo de configuracion alternativo
  --help, -h       Muestra esta ayuda

Ejemplos:
  sudo -E ./backup.sh all
  ./backup.sh docs --no-drive
  ./backup.sh docs --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    docs|plex|all) SUBCOMMAND="$1" ;;
    --dry-run)     DRY_RUN=1 ;;
    --no-cloud)    NO_CLOUD=1 ;;
    --no-drive)    NO_DRIVE=1 ;;
    --verbose|-v)  VERBOSE=1 ;;
    --config)
      [[ $# -ge 2 ]] || { echo "Falta el valor de --config" >&2; exit 1; }
      CONFIG_FILE="$2"; shift ;;
    --config=*)    CONFIG_FILE="${1#*=}" ;;
    --help|-h)     usage; exit 0 ;;
    *)
      echo "Opcion desconocida: $1" >&2
      echo "" >&2
      usage >&2
      exit 1 ;;
  esac
  shift
done

if [[ -z "$SUBCOMMAND" ]]; then
  usage >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Usuario real (funciona tanto como usuario normal como con sudo)
# ---------------------------------------------------------------------------
if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
  REAL_USER="$SUDO_USER"
  REAL_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
else
  REAL_USER="${USER:-$(id -un)}"
  REAL_HOME="${HOME:-$(getent passwd "$REAL_USER" | cut -d: -f6)}"
fi
export REAL_USER REAL_HOME

# ---------------------------------------------------------------------------
# Configuracion por defecto (se puede sobreescribir en el archivo de config)
# ---------------------------------------------------------------------------
SOURCE_DOCS="$REAL_HOME/Documentos/Documentos"
STAGING_DIR="$REAL_HOME/Descargas"
BACKUP_DRIVE="/media/cesc/mugiwara"                 # disco externo (vfat/FAT32)
HDD_DOCS_DIR="$BACKUP_DRIVE/Backups/Documentos"    # espejo de la nube
HDD_PLEX_DIR="$BACKUP_DRIVE/Backups/Plex"
LOG_DIR="$REAL_HOME/.local/share/backup"
CLOUD_DOCS=( "dropbox:Backups/Documentos" "mega:Backups/Documentos" )
CLOUD_PLEX=( "dropbox:Backups/Plex"       "mega:Backups/Plex" )
KEEP_DISK=2
KEEP_CLOUD=1
KEEP_LOCAL=1                                        # copias en ~/Descargas (staging)
COMPRESS_LEVEL=8
PLEX_BASE="/var/lib/plexmediaserver"
PLEX_DIR="$PLEX_BASE/Library/Application Support/Plex Media Server"
PLEX_EXCLUDE_MEDIA=0                                # 1 = tambien excluir la carpeta Media
NOTIFY=1
RCLONE_CONFIG="$REAL_HOME/.config/rclone/rclone.conf"
export RCLONE_CONFIG

# Archivo de configuracion opcional
if [[ -z "$CONFIG_FILE" ]]; then
  CONFIG_FILE="$REAL_HOME/.config/backup.conf"
fi
if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
fi

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
mkdir -p "$LOG_DIR" 2>/dev/null || true
if [[ $EUID -eq 0 && "$REAL_USER" != "root" ]]; then
  chown "$REAL_USER:$REAL_USER" "$LOG_DIR" 2>/dev/null || true
fi
LOG_FILE="$LOG_DIR/backup_$(date +%F_%H-%M-%S).log"

ts()   { date '+%F %T'; }
log()  { local m; m="$(ts) $*"; printf '%s\n' "$m"; printf '%s\n' "$m" >>"$LOG_FILE"; }
vlog() { [[ $VERBOSE -eq 1 ]] && log "$@"; true; }
warn() { log "ADVERTENCIA: $*"; }
die()  { log "ERROR: $*"; exit 1; }

need() {
  command -v "$1" >/dev/null 2>&1 || die "Falta el comando '$1' en el PATH"
}

human() {
  numfmt --to=iec --suffix=B "$1" 2>/dev/null || printf '%s bytes' "$1"
}

file_size() {
  stat -c '%s' "$1" 2>/dev/null || echo 0
}

notify() {
  [[ "$NOTIFY" -eq 1 ]] || return 0
  command -v notify-send >/dev/null 2>&1 || return 0
  local title="$1" body="$2"
  if [[ $EUID -eq 0 && -n "${SUDO_USER:-}" ]]; then
    runuser -u "$REAL_USER" -- notify-send "$title" "$body" 2>/dev/null || true
  else
    notify-send "$title" "$body" 2>/dev/null || true
  fi
}

# Si se corre con sudo, deja los archivos a nombre del usuario real para que la
# rotacion funcione igual con o sin sudo (se ignora si el FS no lo permite).
fix_owner() {
  [[ $EUID -eq 0 && "$REAL_USER" != "root" ]] || return 0
  chown "$REAL_USER:$REAL_USER" "$@" 2>/dev/null || true
  return 0
}

# ---------------------------------------------------------------------------
# Comprobaciones
# ---------------------------------------------------------------------------
check_drive() {
  if [[ $NO_DRIVE -eq 1 ]]; then
    vlog "Disco omitido (--no-drive)"
    return 0
  fi
  [[ -e "$BACKUP_DRIVE" ]] || die "No existe BACKUP_DRIVE=$BACKUP_DRIVE"
  mountpoint -q "$BACKUP_DRIVE" || die "El disco no esta montado en $BACKUP_DRIVE (conectalo e intenta de nuevo)"
  [[ -w "$BACKUP_DRIVE" ]] || die "Sin permiso de escritura en $BACKUP_DRIVE"
  local testfile="$BACKUP_DRIVE/.backup_wtest_$$"
  touch "$testfile" 2>/dev/null || die "No se puede escribir en $BACKUP_DRIVE"
  rm -f "$testfile"
}

check_space() {
  local dir="$1" need_bytes="$2" label="$3"
  [[ -d "$dir" ]] || mkdir -p "$dir" 2>/dev/null || die "No se pudo crear $dir"
  local avail
  avail="$(df -Pk "$dir" | awk 'NR==2{print $4*1024}')"
  if (( avail < need_bytes )); then
    die "Espacio insuficiente en $label ($dir): necesarios ~$(human "$need_bytes"), disponibles $(human "$avail")"
  fi
}

# ---------------------------------------------------------------------------
# Rotacion
# ---------------------------------------------------------------------------
# Borra en el disco los archivos que casan con el patron, dejando los N mas nuevos.
rotate_disk() {
  local dir="$1" pattern="$2" keep="$3"
  local files f
  mapfile -t files < <(find "$dir" -maxdepth 1 -type f -name "$pattern" -printf '%f\n' | sort -r | tail -n +$((keep + 1)))
  for f in "${files[@]}"; do
    [[ -z "$f" ]] && continue
    log "Borrando en disco: $dir/$f"
    [[ $DRY_RUN -eq 1 ]] && continue
    rm -f -- "$dir/$f" || warn "No se pudo borrar $dir/$f"
  done
}

# Borra en la nube los archivos que casan con el patron, dejando los N mas nuevos.
rotate_cloud() {
  local dest="$1" pattern="$2" keep="$3"
  local names f
  mapfile -t names < <(rclone lsf "$dest" --files-only --include "$pattern" 2>/dev/null | sort -r | tail -n +$((keep + 1)))
  for f in "${names[@]}"; do
    [[ -z "$f" ]] && continue
    log "Borrando en nube: $dest/$f"
    [[ $DRY_RUN -eq 1 ]] && continue
    rclone deletefile "$dest/$f" 2>/dev/null || warn "No se pudo borrar $dest/$f"
  done
}

# ---------------------------------------------------------------------------
# Nube
# ---------------------------------------------------------------------------
verify_cloud() {
  local dest="$1" name="$2" file="$3"
  local local_sz remote_sz
  local_sz="$(file_size "$file")"
  remote_sz="$(rclone lsl "$dest/$name" 2>/dev/null | awk 'NR==1{print $1}')"
  [[ -n "$remote_sz" && "$remote_sz" == "$local_sz" ]]
}

# Sube un archivo a un destino rclone. Para dropbox borra los previos antes de
# subir (la cuota esta ajustada); para mega, si rclone falla, usa mega-put.
upload_one() {
  local dest="$1" file="$2" pattern="$3"
  local remote="${dest%%:*}"
  local name; name="$(basename "$file")"

  log "Subiendo $name -> $dest"
  if [[ $DRY_RUN -eq 1 ]]; then
    log "[dry-run] rclone copyto '$file' '$dest/$name'"
    return 0
  fi

  if [[ "$remote" == "dropbox" ]]; then
    rotate_cloud "$dest" "$pattern" 0
  fi

  if rclone copyto "$file" "$dest/$name" 2>&1 | tee -a "$LOG_FILE"; then
    if ! verify_cloud "$dest" "$name" "$file"; then
      die "La verificacion de subida fallo en $dest ($name)"
    fi
  else
    if [[ "$remote" == "mega" ]]; then
      warn "rclone fallo con MEGA; probando fallback con mega-put"
      mega_upload "$dest" "$file" || die "Fallo la subida a $dest"
    else
      die "Fallo la subida a $dest"
    fi
  fi

  rotate_cloud "$dest" "$pattern" "$KEEP_CLOUD"
}

mega_upload() {
  local dest="$1" file="$2"
  local path="${dest#mega:}"
  need mega-put
  mega-put -c "$file" "/$path" 2>&1 | tee -a "$LOG_FILE"
}

upload_all() {
  local pattern="$1" file="$2"; shift 2
  local dest
  for dest in "$@"; do
    upload_one "$dest" "$file" "$pattern"
  done
}

# ---------------------------------------------------------------------------
# Backup de Documentos
# ---------------------------------------------------------------------------
backup_docs() {
  log "=== Backup de Documentos ==="

  if [[ $DRY_RUN -eq 1 ]]; then
    log "[dry-run] comprimiria '$SOURCE_DOCS' -> '$STAGING_DIR/Documentos_<fecha>.7z' (7z -mx=$COMPRESS_LEVEL)"
    [[ $NO_DRIVE -eq 0 ]] && log "[dry-run] copiaria el archivo a '$HDD_DOCS_DIR/' y rotaria (keep=$KEEP_DISK)"
    [[ $NO_CLOUD -eq 0 ]] && log "[dry-run] subiria a: $(IFS=', '; echo "${CLOUD_DOCS[*]}") y rotaria (keep=$KEEP_CLOUD)"
    return 0
  fi

  need 7z
  [[ $NO_DRIVE -eq 0 ]] && need rsync
  [[ -d "$SOURCE_DOCS" ]] || die "No existe el origen $SOURCE_DOCS"
  check_drive

  mkdir -p "$STAGING_DIR" || die "No se pudo crear $STAGING_DIR"
  local src_bytes; src_bytes="$(du -sb "$SOURCE_DOCS" | cut -f1)"
  check_space "$STAGING_DIR" "$src_bytes" "staging"
  [[ $NO_DRIVE -eq 0 ]] && check_space "$HDD_DOCS_DIR" "$src_bytes" "disco"

  local stamp; stamp="$(date +%F_%H-%M-%S)"
  local archive="$STAGING_DIR/Documentos_$stamp.7z"
  local name; name="$(basename "$archive")"
  local src_parent src_name
  src_parent="$(dirname "$SOURCE_DOCS")"
  src_name="$(basename "$SOURCE_DOCS")"

  log "Comprimiendo $SOURCE_DOCS -> $archive"
  if ! ( cd "$src_parent" && 7z a -t7z -y -mx="$COMPRESS_LEVEL" -mmt=on "$archive" "$src_name" ) 2>&1 | tee -a "$LOG_FILE"; then
    die "Fallo la compresion con 7z"
  fi

  log "Verificando integridad del .7z"
  if ! 7z t "$archive" >/dev/null 2>&1; then
    die "El archivo no pasa la verificacion (7z t)"
  fi
  fix_owner "$archive"
  log "Creado $name ($(human "$(file_size "$archive")"))"

  if [[ $NO_DRIVE -eq 0 ]]; then
    log "Copiando al disco $HDD_DOCS_DIR"
    if ! rsync -rt --no-perms --no-owner --no-group --partial --progress "$archive" "$HDD_DOCS_DIR/"; then
      die "Fallo la copia al disco con rsync"
    fi
    local a b
    a="$(file_size "$archive")"
    b="$(file_size "$HDD_DOCS_DIR/$name")"
    [[ "$a" == "$b" ]] || die "El tamano copiado al disco no coincide ($a vs $b)"
    fix_owner "$HDD_DOCS_DIR/$name"
    rotate_disk "$HDD_DOCS_DIR" 'Documentos_*.7z' "$KEEP_DISK"
  fi

  if [[ $NO_CLOUD -eq 0 ]]; then
    upload_all 'Documentos_*.7z' "$archive" "${CLOUD_DOCS[@]}"
  fi

  rotate_disk "$STAGING_DIR" 'Documentos_*.7z' "$KEEP_LOCAL"

  log "Backup de Documentos completado"
  notify "Backup Documentos" "Completado: $name ($(human "$(file_size "$archive")"))"
}

# ---------------------------------------------------------------------------
# Backup de Plex
# ---------------------------------------------------------------------------
backup_plex() {
  log "=== Backup de Plex ==="

  if [[ $DRY_RUN -eq 1 ]]; then
    log "[dry-run] detendria plexmediaserver, crearia '$HDD_PLEX_DIR/plexmediaserver_<fecha>.tar.bz2'"
    log "[dry-run] excluiria: Diagnostics, Logs, Updates, Crash Reports, Cache, Codecs, Plug-in Support/Caches"
    log "[dry-run] reiniciaria plexmediaserver y subiria a: $(IFS=', '; echo "${CLOUD_PLEX[*]}")"
    return 0
  fi

  [[ $EUID -eq 0 ]] || die "El backup de Plex requiere root. Ejecuta: sudo -E $SCRIPT_NAME plex"
  [[ $NO_DRIVE -eq 0 ]] || die "--no-drive no es valido para Plex (el tar se escribe directamente en el disco)"
  need tar
  need bzip2
  systemctl cat plexmediaserver.service >/dev/null 2>&1 || die "No existe el servicio plexmediaserver.service"
  [[ -d "$PLEX_DIR" ]] || die "No existe $PLEX_DIR"
  [[ -d "$PLEX_BASE" ]] || die "No existe $PLEX_BASE"
  check_drive

  local src_bytes; src_bytes="$(du -sb "$PLEX_BASE" 2>/dev/null | cut -f1 || echo 0)"
  check_space "$HDD_PLEX_DIR" "$src_bytes" "disco"

  local stamp; stamp="$(date +%F_%H-%M-%S)"
  local archive="$HDD_PLEX_DIR/plexmediaserver_$stamp.tar.bz2"
  local name; name="$(basename "$archive")"

  local excludes=(
    --exclude="$PLEX_DIR/Diagnostics"
    --exclude="$PLEX_DIR/Logs"
    --exclude="$PLEX_DIR/Updates"
    --exclude="$PLEX_DIR/Crash Reports"
    --exclude="$PLEX_DIR/Cache"
    --exclude="$PLEX_DIR/Codecs"
    --exclude="$PLEX_DIR/Plug-in Support/Caches"
  )
  [[ "$PLEX_EXCLUDE_MEDIA" -eq 1 ]] && excludes+=( --exclude="$PLEX_DIR/Media" )

  log "Deteniendo plexmediaserver.service"
  systemctl stop plexmediaserver.service
  trap 'log "Reiniciando plexmediaserver.service"; systemctl start plexmediaserver.service 2>/dev/null || true' EXIT

  log "Creando $archive"
  if ! tar -cjpvf "$archive" "${excludes[@]}" "$PLEX_BASE" 2>&1 | tee -a "$LOG_FILE"; then
    die "Fallo la creacion del tar de Plex"
  fi

  log "Iniciando plexmediaserver.service"
  systemctl start plexmediaserver.service
  trap - EXIT

  fix_owner "$archive"
  log "Verificando integridad del .tar.bz2"
  if ! tar -tjf "$archive" >/dev/null 2>&1; then
    die "El archivo no pasa la verificacion (tar -tjf)"
  fi
  log "Creado $name ($(human "$(file_size "$archive")"))"

  rotate_disk "$HDD_PLEX_DIR" 'plexmediaserver_*.tar.bz2' "$KEEP_DISK"

  if [[ $NO_CLOUD -eq 0 ]]; then
    upload_all 'plexmediaserver_*.tar.bz2' "$archive" "${CLOUD_PLEX[@]}"
  fi

  log "Backup de Plex completado"
  notify "Backup Plex" "Completado: $name ($(human "$(file_size "$archive")"))"
}

# ---------------------------------------------------------------------------
# Ejecucion
# ---------------------------------------------------------------------------
run_all() {
  local rc=0
  if ! ( backup_docs ); then
    rc=1
    warn "Fallo el backup de Documentos"
  fi
  if ! ( backup_plex ); then
    rc=1
    warn "Fallo el backup de Plex"
  fi
  return $rc
}

# Lock para evitar ejecuciones simultaneas.
# Se guarda junto a los logs y no en /tmp: /tmp es sticky y fs.protected_regular
# impide que root abra con O_CREAT un archivo que creo el usuario.
LOCK_FILE="$LOG_DIR/backup.lock"
: >"$LOCK_FILE" 2>/dev/null || true
fix_owner "$LOCK_FILE"
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  die "Ya hay una ejecucion de $SCRIPT_NAME en curso"
fi

log "Iniciando $SCRIPT_NAME $SUBCOMMAND (usuario real: $REAL_USER)"
log "Log: $LOG_FILE"

rc=0
case "$SUBCOMMAND" in
  docs) backup_docs || rc=$? ;;
  plex) backup_plex || rc=$? ;;
  all)  run_all      || rc=$? ;;
esac

if [[ $rc -eq 0 ]]; then
  log "Proceso terminado correctamente"
else
  log "Proceso terminado con errores (codigo $rc)"
  notify "Backup" "Termino con errores (ver $LOG_FILE)"
fi
exit "$rc"
