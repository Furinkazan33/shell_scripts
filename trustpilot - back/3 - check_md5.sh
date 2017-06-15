#! /bin/bash

easy="e4820b45d2277f3844eac66c903e84be"
hard="23170acc097c24edb98fc5488ab033fe"
hardest="665e5bcb0c20062fe8abaaf4628bb154"

# hard is not found ?!? I miss something...
check() {
  while read line; do
    md5sum=$(echo -n $line | md5sum)
    md5=($md5sum)

    [ $md5 == $easy ] && echo "easy => $line"
    [ $md5 == $hard ] && echo "hard => $line"
    [ $md5 == $hardest ] && echo "hardest => $line"
  done
} < "${1:-/dev/stdin}"


cat "2 - unique_seq.txt" | check
