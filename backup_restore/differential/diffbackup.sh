#!/usr/bin/env bash

# Author: Boris Däppen, April 2015
# Use this script at your own risc.
# The author will not grant any form of guarante, nor take responsibility.
# This script can possible damage your system and lead to loss of data!

# Anzeige der Hilfe
if [ $# -ne 2 ]
then
  SKRIPT=$(basename $0)
  echo ""
  echo "  Aufruf: $SKRIPT DATENORDNER VOLLSICHERUNGSORDNER"
  echo ""
  echo "  Gibt Dateien aus, welche seit der Vollsicherung verändert wurden"
  echo ""
  exit 1
fi

# realpath muss auf Debian/Ubuntu nachinstalliert werden
if ! type "realpath" > /dev/null; then
  echo ""
  echo "  Das Programm 'realpath' wird benötigt. Bitte installieren."
  echo "    sudo aptitude install realpath"
  echo "  oder"
  echo "    sudo apt-get install realpath"
  echo ""
  exit 1
fi

# Prüfen ob die angegebenen Pfade existieren und lesbar sind
for i in $1 $2; do
    if [ ! -r $i ]; then
      echo "Ordner nicht lesbar/existen: $i"
      exit 1
    fi
done

# Pfad zu Daten und Fullbackup sollen absolut sein
DATA=$(realpath $1)
FULL=$(realpath $2)


# wir gehen alle Dateien im Daten-Verzeichnis durch...
for i in $(find $DATA -type f)
do
  # pro Datei nehmen wir nur die relative Pfadangabe
  # Bsp: aus /home/user/data/fotos/ich.jpg wird /fotos/ich.jpg
  # (interne string-manipulation mit bash)
  FILE=${i#${DATA}}
  
  # Abfragen der Modifikationszeit für Dateien im Daten und Backupordner
  DATA_STATS=$(stat --printf="%Y" $DATA$FILE)
  FULL_STATS=$(stat --printf="%Y" $FULL$FILE)

  # die Dateien im Dataordner auflisten welche ein anderes Änderungsdatum
  # haben als im Ordner des Fullbackup
  if [ "$DATA_STATS" != "$FULL_STATS" ]
  then
    echo $i
  fi
done

