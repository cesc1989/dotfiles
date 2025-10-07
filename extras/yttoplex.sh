#!/bin/bash

# Script optimizado para descargar playlists de YouTube
# Uso: ./yttoplex.sh -u "URL" -p "PREFIJO" -d "DESTINO"

URL=""
PREFIX=""
DEST_DIR=""
DOWNLOAD_DIR="$HOME/yttoplex-downloads"
ARCHIVE_FILE="downloaded_videos.txt"

show_help() {
  echo "Uso: $0 -u URL -p PREFIJO -d DESTINO"
  echo ""
  echo "Opciones:"
  echo "  -u URL      URL de la playlist de YouTube (obligatorio)"
  echo "  -p PREFIJO  Prefijo para los archivos descargados (obligatorio)"
  echo "  -d DESTINO  Directorio destino para copiar los archivos (obligatorio)"
  echo "  -h          Mostrar esta ayuda"
  exit 1
}

while getopts "u:p:d:h" opt; do
  case $opt in
    u) URL="$OPTARG" ;;
    p) PREFIX="$OPTARG" ;;
    d) DEST_DIR="$OPTARG" ;;
    h) show_help ;;
    *) show_help ;;
  esac
done

if [[ -z "$URL" || -z "$PREFIX" || -z "$DEST_DIR" ]]; then
  echo "Error: Faltan argumentos obligatorios"
  show_help
fi

if ! command -v yt-dlp &> /dev/null; then
  echo "Error: yt-dlp no está instalado. Instálalo con: pip install yt-dlp"
  exit 1
fi

echo "Iniciando descarga de playlist..."
echo "URL: $URL"
echo "Prefijo: $PREFIX"
echo "Destino: $DEST_DIR"
echo ""

cd "$DOWNLOAD_DIR"

yt-dlp -ciw -S "res:1080,fps" \
  --download-archive "$ARCHIVE_FILE" \
  -o "${PREFIX}_%(title)s.%(ext)s" \
  --restrict-filenames \
  "$URL"

echo ""
echo "Copiando archivos al destino $DEST_DIR"
cp -v $DOWNLOAD_DIR/* "$DEST_DIR/"

echo ""
echo "Proceso completado!"
