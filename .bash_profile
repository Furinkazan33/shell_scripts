#!/bin/bash

EMAIL="yourmail@example.com"

# Send mail
sm()  {
    TO=$([ -z "$2" ] && echo "$EMAIL" || echo "$2")
    SUBJECT="Envoi d'un fichier"
    FILE=$1
    
    cat $FILE | uuencode `basename $FILE` | mail -s "$SUBJECT" $TO
}

atoi() {
    echo $(expr $1 + 0)
}

my_help()
{
	exec 3>tmp_my_help

	echo 'read:while read ligne; do'>&3
	echo 'read:    echo $ligne'>&3
	echo 'read:done < "/dev/stdin"'>&3
	echo 'read:done < "${2:-/dev/stdin}"'>&3

	
	cat tmp_my_help
	rm -f tmp_my_help
}

# Echoes every positions of the searched pattern in the string
positions()
{
    [[ $# -lt 2 ]] && { echo "Usage: positions <pattern> <string>"; return 1; }

    l_pattern=${#1}
    l_string=${#2}
    find=1

    for i in $(seq 0 $(expr $l_string - $l_pattern)); do
        substr=${2:i:l_pattern}
        [[ $1 == $substr ]] && find=0 && echo $(expr $i + 1)
    done

    return $find
}

my_cut()
{
    [[ $# -lt 1 ]] && echo "Usage: my_cut pattern [longueur]" && return 1

    while read ligne; do
        for pos in $(positions $1 "$ligne"); do
            echo $ligne | cut -c$pos-$([[ ! -z $2 ]] && expr $pos + $2 - 1)
        done
    done < "/dev/stdin"
}

is_digit()
{
    [[ "$(echo $l | grep "^[[:digit:]]*$")" ]] && return 0
    return 1
}

vider_favoris() {
    dirs -c
}

ajouter_favoris() {
    [ -r $1 ] && pushd -n $1 > /dev/null
}

lister_favoris() {
    go
}

go() {
    n=$(dirs -v | wc -l)
    ( [[ -z $* ]] || [[ $1 -ge $n ]] ) && dirs -v | tail -n $(expr $n - 1) && return 0

    dir=$(dirs +$1)
    [[ "$dir" == "~" ]] && cd || cd $dir
}

