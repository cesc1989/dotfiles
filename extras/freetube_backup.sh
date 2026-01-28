#!/bin/bash
#
# Copia los archivos basicos de uso de FreeTube a la carpeta
# sincronizada con Mega.
#
# FreeTube solo lo uso en Linux Mint asi que la carpeta Documentos está en Español.

FREETUBE_FOLDER="$HOME/.config/FreeTube"
DESTINATION_FOLDER="$HOME/Documentos/Documentos/Otro Espacio/Degoogle/FreeTube-bkps"

cp $FREETUBE_FOLDER/{profiles,settings,playlists,history}.db "$DESTINATION_FOLDER/"
