# Needs 'brew install antigen' first.
# Use antigen as zsh plugin manager.
source /usr/local/share/antigen/antigen.zsh

# Use zsh-nvm plugin, defer loading
export NVM_LAZY_LOAD=true
antigen bundle lukechilds/zsh-nvm

# Tell antigen we're done
antigen apply

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
export VISUAL="nvim"

# But still use emacs-style zsh bindings
bindkey -e

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

#  Get settings for tiny-care-terminal
source ~/.tinyrc

#  Get settings for Android Studio
source ~/.androidrc

# Start Z utility to change directories easily
. ~/bin/z.sh

