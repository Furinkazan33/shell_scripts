#!/bin/bash

# Fichier en sortie
output=`pwd`/out.txt;
# Création du fichier en sortie
> $output;

# Parcours récursivement un dossier
# parcours_dossier "dossier" "profondeur"
function parcours_dossier ()
{
    # Debug
    echo "Profondeur: $2";
    
    origine=`pwd`;
    cd "$origine/$1";
    dossier="$origine/$1";

    for f in *; do
    
        # Debug
        echo "$dossier/$f";
        
        if [ -f "$dossier/$f" ]; then
        
            echo "$f" >> $output;
            
        elif [ -d "$dossier/$f" ]; then
        
            parcours_dossier "$f" `expr $2 + 1`;
            
        fi
        
    done
}

parcours_dossier "$1" "0";
gzip $output;

