#! /bin/bash

LETTRES="poultryoutwitsants"

# Retourne 0 si le char est présent dans la chaine, 1 sinon
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

#remove_letters "aef" "abfcdefh"

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

# Construit la liste des mots qui correspondent à l'anagramme
get_words_match(){
  > double_match.txt

  while read line; do
    echo "$line$line"
    letters=$LETTRES
    test_mot "$line$line" $letters && echo "$line $line" >> double_match.txt
  done

  wc double_match.txt
} < "${1:-/dev/stdin}"


#cat words_match_single | get_words_match

get_words(){
  local mots=()

  while read line; do
    mots+=($line)
  done

  echo ${mots[@]}
} < "${1:-/dev/stdin}"

mots=($(cat words_match_single | get_words))
maxlength=11

doit(){
  > fic_res_double.txt

  while read line; do
    letters=$LETTRES
    local a=()
    for w in $line; do
      a+=($w)
    done
    letters=$(remove_letters ${a[@]:0:1}${a[@]:1:1} $letters)
    echo "${a[@]:0:1} ${a[@]:1:1} reste:$letters:"

    # for i in `seq 0 ${#mots[@]}`; do
    #   newletters=$letters
    #
    #   test_mot ${mots[@]:$i:1} $newletters
    #
    #   if [ $? -eq 0 ]; then
    #     newletters=$(remove_letters ${mots[@]:$i:1} $newletters)
    #     [ ${#newletters} -eq 0 ] && echo "${a[@]:0:1} ${a[@]:1:1} ${mots[@]:$i:1}" >> fic_res_double.txt
    #   fi
    # done
  done
} < "${1:-/dev/stdin}"

cat double_match.txt | doit
