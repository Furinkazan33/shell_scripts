#!/bin/bash
# Liste tous les fichiers d'un dossier récursivement

#TODO: manage options (getopt)
FOLDER=$1
DEPTH=$2
FULLPATH=$3

MAX_DEPTH=10000

function parcours_dossier_rec() {
  local folder=$1
  local depth=$2
  local maxdepth=$3

  [ $depth -eq $maxdepth ] && return 0

  cd "$folder"
  path=`pwd`

  for file in *; do

    if [ -f "$path/$file" ]; then
      [ -z $FULLPATH ] && echo "$file" || echo "$path/$file"

    elif [ -d "$path/$file" ]; then
      parcours_dossier "$file" `expr $depth + 1`

    fi

  done
}

function parcours_dossier() {
  local folder="$1"
  local depth=$2

  [ -z $depth ] && depth=$MAX_DEPTH

  parcours_dossier_rec "$folder" 0 $depth
}

parcours_dossier "$FOLDER" $DEPTH

