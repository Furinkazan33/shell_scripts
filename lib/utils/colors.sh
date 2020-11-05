#! /bin/bash
#############################################################
# 
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# Colors
#############################################################

declare -A COLORS
COLORS[NO_COLOUR]="\033[0m"
COLORS[GREY]="\033[1;30m"
COLORS[RED]="\033[1;31m"
COLORS[GREEN]="\033[1;32m"
COLORS[YELLOW]="\033[1;33m"
COLORS[DARK_BLUE]="\033[1;34m"
COLORS[PURPLE]="\033[1;35m"
COLORS[BLUE]="\033[1;36m"
COLORS[LIGHTGREY]="\033[1;37m"
COLORS[BLACK]="\033[1;38m"
COLORS[OK]=${COLORS[GREEN]}
COLORS[KO]=${COLORS[RED]}

_color_list()
{
  for color in ${!COLORS[@]}; do
    echo $color
  done | sort
}

_color()
{
  [ -z "$1" ] && return 1

  echo "${COLORS[$1]}"
  
  return 0
}

c_echo()
{
  local usage="Usage: c_echo [-h] <color> <message>"

  [ "$1" == "-h" ] && { echo $usage;_color_list; return 0; }

  local color=$(_color $1)
  local message=${*:2}
  local end_color=$(_color NO_COLOUR)
 
  ([ $# -lt 2 ] || [ -z "$color" ] || [ -z "$message" ]) && { echo $usage; return 1; } 

  echo -e "$color$message$end_color"

  return 0
}

c_echoi()
{
  local usage="Usage: c_echoi [-h] <number of indent> <color> <message>"
  [ "$1" == "-h" ] && { echo $usage; _color_list; return 0; }
  
  local color=$(_color $2)

  ([ $# -lt 3 ] || [[ ! $1 =~ ^[0-9]+$ ]] || [ -z $color ]) && { echo $usage; return 1; }

  local indentation=$(head -c $1 < /dev/zero | tr '\0' '\40')
  local message=${*:3}
  local c_message=$(c_echo $2 $message)

  echo -e "$indentation$c_message"

  return 0
}


