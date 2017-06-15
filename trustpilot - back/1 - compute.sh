#!/bin/bash

LETTRES="poultryoutwitsants"
in="words_match_single"
out="1 - compute.txt"
param="param"

# Get words into an array
get_words(){
  local mots=()

  while read line; do
    mots+=($line)
  done

  echo ${mots[@]}
} < "${1:-/dev/stdin}"

# For each word in $in, test_mot $word $LETTERS returns 0
# wc -l $in gives 1658
mots=$(cat $in | get_words)
# The algo that computes that is not here :)
maxlength=11

# Returns 0 iff char is present in the string
find(){
  local char=$1
  local chars=$2

  local i=0
  while [ $i -lt ${#chars} ]; do
    [ $char == ${chars:$i:1} ] && return 0
    i=$(($i+1))
  done

  return 1
}

remove_letter(){
  local char=$1
  local chars=$2
  local res=""
  local found=0

  local i=0
  while [ $i -lt ${#chars} ]; do
    if [ $char == ${chars:$i:1} ]; then
      if [ $found -eq 0 ]; then
        found=1
      else
        res+=${chars:$i:1}
      fi
    else
      res+=${chars:$i:1}
    fi
    i=$(($i+1))
  done

  echo $res
}

remove_letters(){
  local letters=$1
  local chars=$2
  local found=0

  local i=0
  while [ $i -lt ${#letters} ]; do
    chars=$(remove_letter ${letters:$i:1} $chars)

    i=$(($i+1))
  done

  echo $chars
}

# All the word letters ($1) are contained in the letters given ($2)
test_mot(){
  local mot=$1
  local len=${#mot}
  local chars=$2

  local i=0
  while [ $i -lt $len ]; do
    find ${mot:$i:1} $chars
    if [ $? -eq 0 ]; then
      chars=$(remove_letter ${mot:$i:1} $chars)
    else
      return 1
    fi
    i=$(($i+1))
  done

  return 0
}


compute() {
  local LETTRES=${*:1:1}
  local mots=(${*:2})
  local lliste=${#mots[@]}
  local resultat

  local restart=()
  for p in $(cat $param); do
    restart+=($p)
  done
  local restarti=${restart[@]:0:1}
  local restartj=${restart[@]:1:1}

  #echo $restarti $restartj

  local i=$restarti

  while [ $i -le $lliste ]; do
    lettresi=$LETTRES
    resultati=""

    mot=${mots[@]:$i:1}
    test_mot $mot $lettresi && lettresi=$(remove_letters $mot $lettresi) && resultati=$mot

    # Word not found or no more letter left
    if [ $? -ne 0 ] || [ ${#lettresi} -eq 0 ]; then
      i=$(($i+1))
      continue
    fi

    if [ $i == $restarti ]; then
      local j=$restartj
    else
      local j=$(($i+1))
    fi

    while [ $j -le $lliste ]; do
      resultatj=$resultati
      lettresj=$lettresi

      echo $i" "$j
      echo "${mots[@]:$i:1} ${mots[@]:$j:1}"

      mot=${mots[@]:$j:1}
      test_mot $mot $lettresj && lettresj=$(remove_letters $mot $lettresj) && resultatj+=" "$mot

      # Word not found or no more letter left
      if [ $? -ne 0 ] || [ ${#lettresj} -eq 0 ]; then
        j=$(($j+1))
        continue
      fi

      # Too many letters left
      if [ ${#lettresj} -gt $maxlength ]; then
        j=$(($j+1))
        continue
      fi

      local k=$(($j+1))

      while [ $k -le $lliste ]; do
        resultatk=$resultatj
        lettresk=$lettresj
        #echo $i" "$j" "$k
        #echo "${mots[@]:$i:1} ${mots[@]:$j:1} ${mots[@]:$k:1}"

        mot=${mots[@]:$k:1}

        # More remaining letters that the word length
        if [ ${#lettresk} -ne ${#mot} ]; then
          k=$(($k+1))
          continue
        fi

        # Word found (and no more letters)
        test_mot $mot $lettresk && resultatk+=" "$mot && echo $resultatk >> $out

        k=$(($k+1))
      done
      j=$(($j+1))
    done
    i=$(($i+1))
  done
}

compute $LETTRES $mots
