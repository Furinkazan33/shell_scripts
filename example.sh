#! /bin/bash

###########################################
# One example of how to import dependencies
###########################################


# First, we need to set these constants and source the dependencies file

PROJECT_ROOT=.
LIB=./lib
. $LIB/sysadmin/dependencies.sh


# Then we can add our dependencies like so

# Optional
dep_add colors
# Required
dep_add test.sh || exit 1;
dep_add error.sh || exit 1;


# Example with sourced files functions

# Function from colors.sh
dep_exist colors && { c_echo BLUE "Colored message"; } || { echo "Simple message"; }

# Function from test.sh
is_alpha d qdfsdf sdf dfg dfg && echo "Alpha test ok"

