if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Add directory colors to macOS shell
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Show user in color153, short host in color219, curr working dir as prompt
export PS1="%F{153}%n%f@%F{219}%m%f %1~%% "

# Set Neovim as default editor
export EDITOR="nvim"

# Use ripgrep to find hidden files (but ignore node_modules and .git folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!*node_modules*" -g "!*.git*" -g "!*.DS_Store"'

# FZF customizations
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fuzzy open file with 'fo' command in terminal
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR

fo() {
  local out file key
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# For NVM (Node Version Manager)
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#
# Fix NVM slow startup
# https://www.growingwiththeweb.com/2018/01/slow-nvm-init.html
#
# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
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
. ~/bin/z.sh

