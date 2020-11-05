#! /bin/bash
#############################################################
# 
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# System administration functions
#############################################################

# Useful variable definitions
ROOT_UID=0
E_NOTROOT=101
MAXRETVAL=255
SUCCESS=0
FAILURE=-1

f_list() {
    echoc 3 DARK_BLUE 'is_admin [<usernames list>]'
    echoc 3 DARK_BLUE 'is_installed <packages list>'

}


is_admin() {
    [ -z "$*" ] && (groups | grep -q sudo && return 0 || return 1)

    for user in $*; do
        groups $user | grep -q sudo || return 1
    done

    return 0
}

is_installed() {
    for p in $*; do
        command -v $p &> /dev/null || return 1
    done
    
    return 0
}

is_root() {
    [ "$UID" -ne "$ROOT_UID" ] && return 1
    return 0
}


