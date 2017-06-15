#!/bin/bash

anagram="poultry outwits ants"
LETTERS="poultryoutwitsants"


contains(){
  local char=$1
  local letters=$2

  i=0
  while [ $i -lt ${#letters} ]; do
    [ ${letters:$i:1} == $char ] && return 0
    i=$(($i+1))
  done

  return 1
}

remove(){
  local char=$1
  local letters=$2
  local tmp=""
  local notfound=1

  i=0
  while [ $i -lt ${#letters} ]; do
    if [ ${letters:$i:1} != $char ]; then
      tmp+=${letters:$i:1}
    elif [ $notfound -eq 1 ]; then
      notfound=0
    else
      tmp+=${letters:$i:1}
    fi
    i=$(($i+1))
  done

  echo $tmp
}


word_match(){
  local word=$1
  #local letters=${*:2}
  local tmp=$letters
  local i=0

  echo $letters

  while [ $i -lt ${#word} ]; do
    contains ${word:$i:1} $letters
    if [ $? -eq 0 ]; then
      letters=$(remove ${word:$i:1} $letters)
      echo "remove:"$letters
    else
      letters=$tmp
      echo "restore:"$letters
      return 1
    fi
    i=$(($i+1))
  done
  return 0
}


word_match "outwits" $letters && echo $letters
word_match "ytpoul" $letters && echo $letters
word_match "arnts" $letters && echo $letters

# Construit la liste des mots qui correspondent à l'anagramme
# get_words_match(){
#   > words_match
#
#   while read line; do
#     letters=$LETTERS
#     word_match $line && echo $line >> words_match
#   done
#
#   wc words_match
# } < "${1:-/dev/stdin}"
#
#cat wordlist | get_words_match


# suppression_doublons(){
#   > words_match_single
#   prec=""
#   while read line; do
#     if [ ! "$prec" == "$line" ]; then
#       echo "$line" >> words_match_single
#     fi
#     prec=$line
#   done
#
#   wc words_match_single
# } < "${1:-/dev/stdin}"
#
# cat words_match | suppression_doublons

# get_words(){
#   > words$1
#
#   while read line; do
#     if [ ${#line} -eq $1 ]; then
#       echo "$line" >> words$1
#     fi
#   done
#
#   wc words$1
# } < "/dev/stdin"
#
# cat words_match_single | get_words "4"
# cat words_match_single | get_words "7"


