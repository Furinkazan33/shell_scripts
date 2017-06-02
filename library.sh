#!/bin/bash

# Useful variable definitions
ROOT_UID=0             # Root has $UID 0.
E_NOTROOT=101          # Not root user error. 
MAXRETVAL=255          # Maximum (positive) return value of a function.
SUCCESS=0
FAILURE=-1




get_info ()
{
  zenity --entry       #  Pops up query window . . .
                       #+ and prints user entry to stdout.

                       #  Also try the --calendar and --scale options.
}
#answer=$( get_info )   #  Capture stdout in $answer variable.
#echo "User entered: "$answer""



Usage ()
{
  if [ -z "$1" ];       # longueur chaine nulle.
  then
    msg=filename
  else
    msg=$@
  fi

  echo "Usage: `basename $0` "$msg""
}  
#Usage $*;



Check_if_root ()
{
  if [ "$UID" -ne "$ROOT_UID" ]
  then
    echo "Must be root to run this script."
    exit $E_NOTROOT
  fi
}  



CreateTempfileName ()  # Creates a "unique" temp filename.
{
  prefix=temp
  suffix=`eval date +%s`
  Tempfilename=$prefix.$suffix
}

