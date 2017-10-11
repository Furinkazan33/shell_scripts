#!/bin/bash

# Useful variable definitions
ROOT_UID=0
E_NOTROOT=101
MAXRETVAL=255
SUCCESS=0
FAILURE=-1


popup_dialog() {
  zenity --entry
  #zenity --calendar
  #zenity --scale
}
answer=$(popup_dialog)


check_root() {
  if [ "$UID" -ne "$ROOT_UID" ]; then
    echo "Must be root to run this script."
    exit $E_NOTROOT
  fi
}


create_temp_filename() {
  prefix=temp
  suffix=`eval date +%s`
  echo "$prefix.$suffix"
}

