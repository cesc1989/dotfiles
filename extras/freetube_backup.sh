#!/bin/bash
#
# Copia los archivos basicos de uso de FreeTube a la carpeta
# sincronizada con Mega.
#
# FreeTube solo lo uso en Linux Mint asi que la carpeta Documentos está en Español.

FREETUBE_FOLDER="$HOME/.config/FreeTube"
DESTINATION_FOLDER="$HOME/Documentos/Documentos/Otro Espacio/Degoogle/FreeTube-bkps"
DATED_FOLDER=$(date +%Y-%-m-%d-%H-%M-%S)

echo "Creando carpeta destino del backup $DATED_FOLDER"
echo ""
mkdir "$DESTINATION_FOLDER/$DATED_FOLDER"

echo "Copiando archivos a carpeta destino $DESTINATION_FOLDER/$DATED_FOLDER"
echo ""
cp $FREETUBE_FOLDER/{profiles,settings,playlists,history}.db "$DESTINATION_FOLDER/$DATED_FOLDER/"
