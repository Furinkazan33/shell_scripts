#!/bin/bash
################################################################################
# Author : Mathieu Vidalies 2020
################################################################################
# This script intends to provide a function that runs through folders 
# reccursively and process a treatment for each file and folder encountered
#
# 1/ Edit the code for your needs in the following functions : 
# _file_processing
# _folder_processing
# 2/ Change the tpl_func function name
# 3/ Implement your own functionnalities
################################################################################


############################################################
# File processing function, to edit
# You can just call an external function here
############################################################
function _file_processing() {
  file=$1

  # Example, just printing the file name
  echo "${file}"
}

############################################################
# Folder processing function, to edit
# You can just call an external function here
############################################################
function _folder_processing() {
  folder=$1

  # Example, just printing the folder name
  echo ${folder}
}

############################################################
# Filter function, do not edit
############################################################
function _file_ignore() {
  keep=$1
  file=$2
  pattern=$3

  # No pattern to filter => keeping files
  [ -z "$pattern" ] && return 1

  # There is a poattern
  [ ! -z "$pattern" ] && {

    # Do we keep the files if matching pattern ?
    [ $keep = "0" ] && {
      [[ "${file}" =~ $pattern ]] && return 1 || return 0
    }

    # Do we exclude the files if matching pattern ?
    [ $keep = "1" ] && { 
      [[ "${file}" =~ $pattern ]] && return 0 || return 1
    }
  }
}

############################################################
# The algorithm - do not EDIT
# Do not use this function directly
############################################################
# Run through every folder of the given path
############################################################
function _tpl_func_rec() {
  local keep=$1
  local path=$2
  local depth=$3
  local maxdepth=$4
  local pattern=$5

  [ $depth -ge $maxdepth ] && return 0

  for file in `ls -A ${path}`; do

    # Filtering
    _file_ignore $keep ${file} $pattern && continue
    

    # File processing
    [ -f "${path}/${file}" ] && { 
      _file_processing ${path}/${file}
      continue
    }
    

    # Folder processing
    [ -d "${path}/${file}" ] && { 
      _folder_processing ${path}/${file}
      _tpl_func_rec $keep ${path}/${file} `expr $depth + 1` $maxdepth
    }

  done
}

############################################################
# The calling function which you will use in yours scripts
############################################################
# See -h for help
############################################################
function tpl_func() {
  
  usage() {
    echo "Usage: tpl_func [-h for help] [-d <maxdepth> (default is 10000)] [-i|-k <pattern>] <path>"
  }

  help() {
    echo "This function runs through folders reccursively"
    echo "and process a treatment for each file and folder encountered"
    echo 
    echo "------------"
    echo "Parameters :"
    echo "------------"
    echo "-h           : (optionnal) display this help"
    echo "-d <depth>   : (optionnal) maximum depth to explore"
    echo "-i <pattern> : (optionnal) regular expression to ignore files and folders"
    echo "-k <pattern> : (optionnal) regular expression to keep files and folders"
    echo "<path>       : the path to explore"
    echo
    echo "---------------"
    echo "Exemple calls :"
    echo "---------------"
    echo "Keeping only when starting with \".bash\""
    echo 'tpl_func -d1 -k"^.bash" $HOME'
    echo
    echo "Ignoring name starting with .bash"
    echo 'tpl_func -d1 -i"^.bash" $HOME'
    echo
    echo "Ignoring name exactly \".local\""
    echo 'tpl_func -d1 -i"^.local$" $HOME'
  }
  
  local OPTIND option path maxdepth keep pattern

  while getopts "hd:i:k:" option; do
      case "${option}" in
          h)
              help && return 0
              ;;
          d)
              maxdepth="${OPTARG}"
              ;;
          i)
              keep=1
              pattern="${OPTARG}"
              ;;
          k)
              keep=0
              pattern="${OPTARG}"
              ;;
          *)
              usage && return 1
              ;;
      esac
  done

  shift $((OPTIND-1))
  #echo "Reste $#: $*"

  [ $# -lt 1 ] && usage && return 1

  path="$1"
  [ -z $maxdepth ] && maxdepth=10000
  [ -z "$keep" ] && keep=1

  # Starting the run on the current depth (0)
  _tpl_func_rec $keep ${path} 0 $maxdepth ${pattern}
}



############################################################
# Example calls :
# Starts in the $HOME directory
# -d1 : maximum depth = 1
############################################################

echo "Keeping only when starting with \".bash\""
tpl_func -d1 -k"^.bash" $HOME
echo
echo "Ignoring name starting with .bash"
tpl_func -d1 -i"^.bash" $HOME
echo
echo "Ignoring name exactly \".local\""
tpl_func -d1 -i"^.local$" $HOME

############################################################

