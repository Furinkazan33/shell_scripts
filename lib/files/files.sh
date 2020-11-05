
# input     : -
# output    : stdout : lines <any>
# param     : $1 : regex : find filename pattern
# param     : $2 : regex : grep pattern
# optionnal : -
# info      : greps $2 in all files matching $1 pattern
file_find_grep() 
{
  [ $# -lt 2 ] && {
    echo "Usage: f_all <filename_pattern> <grep_pattern>"
    exit 1
  }

  filename=$1
  pattern=$2

  find . -type f -name "$filename" | xargs fgrep -n "$pattern"
}

# input     : stdin : 2 columns any
# output    : stdout : 2 columns any
# param     : $1 : number : first column
# param     : $2 : number : second column
# optionnal : -
# info      : invert columns $1 and $2
file_invert_cols() 
{
  awk -v first=$1 -v second=$2 '{ t=$first; $first=$second; $second=t; print }'
}

# input     : stdin : 2 columns any
# output    : stdout : any | columns any
# param     : -
# optionnal : $1 : boolean : newline after group ? default is 1
# optionnal : $2 : char : delimiter, default is ' '
# info      : group by the first column
file_group()
{
  local stdin=$(cat -)
  local newline=$1; [ "$newline" == "0" ] && newline=0 || newline=1
  local delim=$2; [ -z "$delim" ] && delim=" "
  local groups=$(echo "$stdin" | sort -u -t"$delim" -k1,1 | cut -d"$delim" -f1)
  local functions

  for group in $groups; do
    functions=$(echo "$stdin" | grep $group | cut -d"$delim" -f2-)
    [ $newline -eq 0 ] && echo "$group" || printf "$group "
    echo $functions
  done
}

# Redirecting outputs to $1 file
redirect_start()
{
  local file=$1

  [ -z "$file" ] && { echo "Usage: redirect_start <file>"; return 1; }

  # Saving stdout to fd3
  exec 3>&1

  # Redirecting stderr and stdout to the file
  exec &>>$file
}

# Stopping redirection after redirect_start
redirect_stop()
{
  exec 1>&3
  exec 2>&3
}


