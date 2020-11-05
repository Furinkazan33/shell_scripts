#! /bin/bash

# Dependencies : 
# structures/list.sh:list_count
# tags

. $LIB/structures/list.sh
. $LIB/files/files/.sh
. $LIB/lang/lang.sh

TAGS_FILE=$PROJECT_ROOT/tags


# info      : 
# reads     : 
# format    : 
# param     : 
# optionnal : 
# output    : 
tags() {
  cat $TAGS_FILE
}

# info      : Give every filenames extension from the tags file
# info      : in the current folder
# reads     : tags file
# format    : -
# param     : -
# optionnal : -
# output    : 1 column <file:extension>
tags_extensions() {
  grep '\.' $TAGS_FILE | grep -v "^!_" | cut -d"." -f2 | cut -d$'\t' -f1
}

# info      :  
# reads     : tags file
# format    : -
# param     : -
# optionnal : -
# optionnal : -
# output    : 2 column <file:extension> <counter> sorted by counter desc
tags_extensions_count() {
  tags_extensions | list_count | sort -n -r -k2
}

# info      : Give all public functions of the tags file
# reads     : tags file
# format    : -
# param     : -
# optionnal : -
# output    : 2 columns <function:name> <file:relativepath>
tags_func_file() {
  grep "()" $TAGS_FILE | grep -v "^!_" | grep -v "^_" | cut -d$'\t' -f1,2
}

# info      : Give all private functions of the tags file
# reads     : tags file
# format    : -
# param     : -
# optionnal : -
# output    : 2 columns <file:relativepath> <function:name>
tags_func_file_priv() {
  grep "()" $TAGS_FILE | grep -v "^!_" | grep "^_" | cut -d$'\t' -f1,2 
}

# info      : 
# reads     : tags file
# format    : -
# param     : -
# optionnal : -
# output    : 2 columns <file:relativepath> <function:name>
tags_file_func() {
  tags_func_file | file_invert_cols 1 2 | sort
}

# info      : Give the current folder most used language
# info      : Which file extension is the most present in the tags file
# reads     : tags file
# format    : -
# param     : -
# optionnal : -
# output    : 1 line <language:name> <file:extension> <counter>
tags_project_lang() {
  tags_extension_most_present | read extension 
  map_extension_lang $extension

  echo $lang
}


