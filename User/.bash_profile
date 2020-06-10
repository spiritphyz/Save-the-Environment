# '.bash_profile' is for interactive login shells while
# '.bashrc' is for non-login shells (like rsync) or
# opening new xterms wile already logged in interactively.
#
# MacOS is different than other Unixes in that it always
# executes bash_profile for new terminal windows, so I'm
# putting all customizations into bash_profile, even
# OS-specific things like colored 'ls' output because
# I will rarely log in remotely to a local Mac machine.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# -W to highlight first unread line, +F to follow mode like tail -f
alias lesswf='less -W +F'

# add homebrew's more modern versions of installed unix utilities
export PATH=/usr/local/bin:$PATH

# opt out of homebrew analytics
# https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
#export HOMEBREW_NO_ANALYTICS=1

# To get lightline-vim working correctly
# Set to xterm colors when outside of Tmux
#export TERM=xterm-256color
#
# Above is bad advice, only terminal emulator
# is supposed to set TERM variable (like iTerm),
# not the shell profile.
# https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/

# add directory colors to OS X shell
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# force colored output for 'less' to get color
export CLICOLOR_FORCE=1

# add unicode octopus to differentiate local prompt
# http://notes.torrez.org/2013/04/put-a-burger-in-your-shell.html
# export PS1="\w 🐙  "
export PS1="\W 🐙  "

# Bind Ctrl-R to reverse-search-history
# http://superuser.com/questions/419670/how-do-i-reload-inputrc-using-a-bash-script
# bind -f ~/.inputrc

# set window title BEFORE running commands
# http://stackoverflow.com/questions/5076127/bash-update-terminal-title-by-running-a-second-command
#trap 'echo -ne "\033]2;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG

# Set vim as default editor (non-Ubuntu distros) for Ctrl-x, Ctrl-e advanced editing
# https://unix.stackexchange.com/questions/73484/how-can-i-set-vi-as-my-default-editor-in-unix
#export VISUAL=vim
#export EDITOR="$VISUAL"
#
# If inside Tmux with my person .tmux.conf, chord is "ctrl-x, x, ctrl-e"
# To set Neovim as Bash visual editor for Ubuntu:
# sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60 # (or /usr/local/bin)
# sudo update-alternatives --config editor

# original nvm script, slows down terminal initialization
#export NVM_DIR="/home/tonyle/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fix nvm slow startup
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

# enable tab completion for known hosts
# https://gist.github.com/aliang/1024466
_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

# Use ripgrep to find hidden files (but ignore node_modules and .git folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!*node_modules*" -g "!*.git*"'

# FZF customizations
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Fuzzy open file with NeoVim with 'fo'
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

# Start Z utility
. /home/tonyle/pbin/z.sh
