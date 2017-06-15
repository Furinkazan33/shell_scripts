#! /bin/bash

in="1 - compute.txt"
out="2 - unique_seq.txt"

> $out

remove_from_seq() {
  local char=$1
  local sequence=${*:2}
  local res=()

  for c in $sequence; do
    if [ ! $c == $char ]; then
      res+=($c)
    fi
  done

  echo ${res[@]}
}

# Computes every sequences possible from 3 words (I assumed no duplicated word):
# a b c, a c b, b a c, b c a, c a b, c b a
unique_seq(){
  # 3 words :)
  local valeursi="0 1 2"

  while read line; do
    local words=()

    for word in $line; do
      words+=($word)
    done

    for i in $valeursi; do
      local valeursj=$(remove_from_seq $i $valeursi)

      for j in $valeursj; do
        local valeursk=$(remove_from_seq $j $valeursj)

        for k in $valeursk; do
          echo "${words[@]:$i:1} ${words[@]:$j:1} ${words[@]:$k:1}" >> $out

        done

      done

    done

  done
} < "${1:-/dev/stdin}"

cat $in | unique_seq
