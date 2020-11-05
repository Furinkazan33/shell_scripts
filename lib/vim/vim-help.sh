#! /bin/bash



# info      :
# reads     :
# format    :
# param     :
# optionnal :
# output    :
function vim_help_completion()
{
  echo "Completion"
  echo "^x^n : this file"
  echo "^x^f : filenames"
  echo "^x^] : tags"
  echo "^n   : anything"
  echo "^n and ^p : back and forth"
}

# info      :
# reads     :
# format    :
# param     :
# optionnal :
# output    :
vim_help_command_line()
{
  echo "Command-line"
  echo "ctrl-R nom_buffer <CR> pour coller la commande copiée"
  echo ":history puis : flêches haut bas pour naviguer"
  echo "q: edition des commandes, <CR> pour exécuter"
}

# info      :
# reads     :
# format    :
# param     :
# optionnal :
# output    :
vim_help()
{
  vim_help_completion
  vim_help_command_line

}


