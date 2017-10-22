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

tlv_find()
{
    [[ $# -lt 1 ]] && echo "Usage: find_tlv id" && return 1
    OLDIFS=$IFS
    IFS=$'\n'

    dico=$(grep -E "^($(atoi $1);)" $HOME/bin/perl/conf/DicoTelem.txt) && echo $dico
    l_dico=$(echo $dico | cut -f4 -d";")

    while read tlv; do
        res=$(echo $tlv | my_cut $1 50)

        for r in $res; do
            l=$(echo $r | cut -c-5-7)

      	    is_digit $l && [[ $(atoi $l) -ne 0 ]] && [[ $(atoi $l) -le $l_dico ]] && \
            donnee=$(echo $r | cut -c-8-$(expr 8 + $(atoi $l) - 1)) && \
            echo -e "id:$1\tlongueur:$(atoi $l)\tdonnee:$donnee"
        done

    done < "/dev/stdin"

    IFS=$OLDIFS
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

my_gcc() { 
    base=`basename $1`;
    fic=${base%%.*};
    gcc $1 -o $C_BIN/$fic;
    echo "binairee crÃ©Ã© $C_BIN/$fic"; 
} 

