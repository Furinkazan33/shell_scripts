#! /bin/bash

###########################################
# One example of how to import dependencies
###########################################

# First, we need to set these constants and source the dependencies file
PROJECT_ROOT=.
LIB=./lib
. $LIB/sysadmin/dependencies.sh


# Then we can add our dependencies like so :
dep1=$(dep_find colors.sh) && source $dep1 || { echo $dep1; dep1=""; }
dep2=$(dep_find test.sh)   && source $dep2 || { echo $dep2; dep2=""; }
dep3=$(dep_find error.sh)  && source $dep3 || { echo $dep3; dep3=""; }


# Example with sourced files functions
[ ! -z "$dep1" ] && {
  echo "Test from $dep1"
  c_echo BLUE "Dependency importation success !"
  echo
} || { echo "Failed to source colors.sh, see error message"; }

[ ! -z "$dep2" ] && {
  echo "Test from $dep2"
  is_alpha d qdfsdf sdf dfg dfg && echo "Alpha test ok"
  echo
} || { echo "Failed to source test.sh", see error message; }

[ ! -z "$dep3" ] && {
  echo "Test from $dep3"
  #
} || { echo "Failed to source error.sh, see error message"; echo; }


