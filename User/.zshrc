# Needs 'brew install antigen' first
# Use antigen as zsh plugin manager.
source /usr/local/share/antigen/antigen.zsh

# Use zsh-nvm plugin, defer loading
#export NVM_LAZY_LOAD=true
#antigen bundle lukechilds/zsh-nvm

# Tell antigen we're done
antigen apply

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Ignore commands with leading space from history
setopt histignorespace

# Add directory colors to macOS shell
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Neovim unsets the COLORTERM VARIABLE, need to set again for bat utility
if [ -n "${NVIM_LISTEN_ADDRESS+x}" ]; then
  export COLORTERM="truecolor"
fi

# Load version control information
# PROMPT_SUBST must be before prompt customizations to delay evaluation
setopt PROMPT_SUBST
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
# %b will be git branch name
# %F{147} color start is lightsteelblue, end with %f
zstyle ':vcs_info:git:*' formats ' %F{147}%b%f '

# Show user in color153, short host in color219, curr working dir as prompt
# Use 2 lines for long server names and long current working directory
# Add git branch name ${vcs_info_msg_0_}
# Must use single quotes to delay evaluation and show new switched branch
NEWLINE=$'\n'
PROMPT='%F{153}%n%f@%F{219}%7>>%m%>>%f ${vcs_info_msg_0_:-}%1~${NEWLINE}$ '

# Set Neovim as default editor
#export EDITOR="nvim"
export EDITOR="vim"
#export VISUAL="nvim"
export VISUAL="vim"

# But still use emacs-style zsh bindings
bindkey -e

# Edit current command in editor with ctrl-x ctrl-e
# If not available on server, can use 'fc' to edit last command in history
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Use ripgrep to find hidden files (but ignore node_modules and .git folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!*node_modules*" -g "!*.git*" -g "!*.DS_Store"'
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse  --info=inline --margin=1 --padding=0 --preview-window 'up,70%,border-bottom'"

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

# Run fnm NodeJS helper
#eval "$(fnm env --use-on-cd)"

# Rely on pyenv to manage multiple globally-installed Python and pip
# https://opensource.com/article/19/5/python-3-default-mac
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Start zoxide utility to change directories easily
# Needs installation first:
#   macOS  - brew install zoxide
#   Ubuntu - apt install zoxide
eval "$(zoxide init zsh)"

# Look up command options for Unix utilities
# cheat tar
function cheat() {
  curl cht.sh/$1
}

# Save command history; helps to put at end of file
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
