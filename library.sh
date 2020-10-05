#!/bin/bash

# Useful variable definitions
ROOT_UID=0
E_NOTROOT=101
MAXRETVAL=255
SUCCESS=0
FAILURE=-1

function is_root() {
    [ "$UID" -ne "$ROOT_UID" ] && return 1
    return 0
}

function check_root() {
    echo "Checking if root"
    is_root && { echo "==> OK"; return 0; }
    
    echo " ==> KO"
    echo
    echo "Must be root to run this script."
    exit $E_NOTROOT
}

function get_tmp_string() {
  echo `eval date +%s`
}

