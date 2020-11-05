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
# Filter function - DO NOT EDIT
############################################################
function _file_ignore() {
  keep=$1
  file=$2
  shift 2
  patterns=$*

  for p in $patterns; do
    
    # Matching pattern
    [[ "${file}" =~ $p ]] && {

      # Keeping the file
      [ $keep = "0" ] && return 1

      # Ignoring the file
      [ $keep = "1" ] && return 0
    }

  done

  # No matching pattern
  [ $keep = "0" ] && return 0
  [ $keep = "1" ] && return 1
}

############################################################
# The algorithm - DO NOT EDIT
# Do not use this function directly
############################################################
# Run through every folder of the given path
############################################################
function _tpl_func_rec() {
  local keep=$1
  # 0 => filter both files and folders, 1 => only files, 2 => only folders
  local f_option=$2
  local path=$3
  local depth=$4
  local maxdepth=$5
  shift 5
  local patterns=$*


  [ $depth -ge $maxdepth ] && return 0

  for file in `ls -A ${path}`; do    

    # File processing
    [ -f "${path}/${file}" ] && { 
      
      # Filtering
      ([ $f_option -eq 0 ] || [ $f_option -eq 1 ]) && {
        _file_ignore $keep ${file} $patterns && continue
      }
      
      _file_processing ${path}/${file} && continue
    }
    

    # Folder processing
    [ -d "${path}/${file}" ] && { 

      # Filtering
      ([ $f_option -eq 0 ] || [ $f_option -eq 2 ]) && {
        _file_ignore $keep ${file} $patterns && continue
      }

      _folder_processing ${path}/${file}
      
      _tpl_func_rec $keep $f_option ${path}/${file} `expr $depth + 1` $maxdepth $patterns
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
    echo "Usage: tpl_func [-h for help] [-d <maxdepth> (default is 10000)] [-i|-k <pattern>] [-f|-F] <path>"
  }

  help() {
    echo "This function runs through folders reccursively"
    echo "and process a treatment for each file and folder encountered"
    echo 
    echo "------------"
    echo "Parameters :"
    echo "------------"
    echo "-h                 : (optionnal) display this help"
    echo "-d <depth>         : (optionnal) maximum depth to explore (default is 10000)"
    echo "-i <patterns list> : (optionnal) regular expressions to ignore files and folders"
    echo "-k <patterns list> : (optionnal) regular expressions to keep files and folders"
    echo "-f                 : (optionnal) Filtering only on files."
    echo "                     When no option -i or -k is given, this will ignore all files"
    echo "-F                 : (optionnal) Filtering only on folders"
    echo "                     When no option -i or -k is given, this will ignore all folders"
    echo "<path>             : the path to explore"
    echo
    echo "---------------"
    echo "Exemple calls :"
    echo "---------------"
    echo 'Keeping only when starting with ".bash"'
    echo 'tpl_func -d1 -k"^\.bash" $HOME'
    echo
    echo 'Ignoring name starting with ".bash"'
    echo 'tpl_func -d1 -i"^\.bash" $HOME'
    echo
    echo 'Ignoring name exactly ".local"'
    echo 'tpl_func -d1 -i"^\.local$" $HOME'
    echo
    echo 'Ignoring files starting with ".v" or ".s" or containing "ash" or ending with "s"'
    echo 'tpl_func -d1 -i"^\.v ^\.s ash s$" $HOME'
    echo 
    echo 'Filtering on on files'
    echo 'tpl_func -d3 -i"o" -f $HOME'
    echo 
    echo 'Ignoring folders starting with "."'
    echo 'tpl_func -d3 -i"^\." -F $HOME'
    echo
    echo 'Ignoring all folders'
    echo 'tpl_func -i"." -F $HOME or tpl_func -F $HOME'
    echo
    echo 'Ignoring all files'
    echo 'tpl_func -d1 -f $HOME'
  }
  
  local OPTIND option path maxdepth keep pattern f_option

  while getopts "hd:i:k:fF" option; do
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
          f)
              # Filter only files
              f_option=1
              ;;
          F)
              # Filter only folders
              f_option=2
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
  [ -z "$keep" ] && keep=0
  [ -z "$f_option" ] && f_option=0

  # Starting the run on the current depth (0)
  _tpl_func_rec $keep $f_option ${path} 0 $maxdepth ${pattern}
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

