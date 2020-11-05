

dep_check_constants() {
  [ -z "$LIB" ] && { echo "\$LIB not set !"; return 1; }
  [ -z "$PROJECT_ROOT" ] && { echo "\$PROJECT_ROOT not set !"; return 1; }
  return 0
}


dep_constants() {
  echo "\$PROJECT_ROOT=$PROJECT_ROOT"
  echo "\$LIB=$LIB"
  return 0
}


dep_find() {
  local file="$1"

  [ -f $file ] && { source $file; return 0; }
  
  dep_check_constants

  [ -f $LIB/$file ] && { source $LIB/$file; return 0; }

  [ ! "$file" == `basename $file` ] && {
    echo "Path not found : $LIB/$file"
    echo "Correct $file or try with the filename only : `basename $file`"
    return 1
  }

  local found=$(find $LIB -type f -name $file)
  local n=$(echo "$found" | wc -w)
  [ $n -eq 0 ] && { echo "File not found in \$LIB=$LIB : $file"; return 1; }
  [ $n -gt 1 ] && { echo "$n files found in \$LIB=$LIB : "; echo "$files"; return 1; }

  #echo "1 file found : $found"
  echo "$found"

  return 0
}


