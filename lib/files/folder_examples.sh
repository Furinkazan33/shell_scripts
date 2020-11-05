#!/bin/bash
################################################################################
# Author : Mathieu Vidalies 2020
################################################################################
# 
################################################################################

. folder.sh

############################################################
# Example calls :
# Starts in the $HOME directory
# -d1 : maximum depth = 1
############################################################

echo "Keeping only when starting with \".bash\""
tpl_func -d1 -k"^.bash" $HOME
echo
echo "Ignoring name starting with .bash"
tpl_func -d1 -i"^.bash" $HOME
echo
echo "Ignoring name exactly \".local\""
tpl_func -d1 -i"^.local$" $HOME

############################################################

