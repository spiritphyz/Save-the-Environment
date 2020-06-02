# Add aliases in separate file
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Add directory colors to macOS shell
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Show short hostname, current working directory
export PS1="%B%m%b %1~%% "

# Fix NVM slow startup on new terminal windows
#
# Defers initialization of nvm until nvm, node or a node-dependent command is
# run. Only run once if .bashrc gets sourced multiple times by checking if
# __init_nvm is a function.
#
# https://www.growingwiththeweb.com/2018/01/slow-nvm-init.html
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type -t __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

# Start Z utility to change directories easily
. /Users/kyivdev/pbin/z-utility/z.sh
