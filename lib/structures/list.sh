#! /bin/bash

# Compte le nombre d'occurences de chaque element
list_count() {
  unset ELEMENTS
  declare -A ELEMENTS

  elements=$(cat -)

  for e in $elements; do
    if [ -z ${ELEMENTS[$e]} ]; then
      ELEMENTS[$e]=1
    else
      ELEMENTS[$e]=$((${ELEMENTS[$e]}+1))
    fi
  done

  for k in ${!ELEMENTS[@]}; do
    echo "$k ${ELEMENTS[$k]}"
  done

  return 0
} 

# Donne la ligne "clé nombre" avec le nombre le plus grand
list_max() {
  max=0

  while read k v; do
     [ $v -gt $max ] && { max=$v; max_count=$k; }
  done

  echo "$max_count $max"
}


