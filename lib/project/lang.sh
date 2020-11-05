

# info      : Map file extension to language namea
# info      : Which file extension is the most present in the tags file
# reads     : -
# format    : -
# param     : $1 <file:extension>
# optionnal : -
# output    : line <language:name>
lang_map_extension_lang() {
    case $lang in
      sh) echo shell;;
      py) echo python;;
      c) echo c;;
      js) echo javascript;;
      rb) echo ruby;;
      *) echo unknown;;
    esac
}


