# '.bash_profile' is for interactive login shells while
# '.bashrc' is for non-login shells (like rsync) or 
# opening new xterms wile already logged in interactively.
#
# MacOS is different than other Unixes in that it always 
# executes bash_profile for new terminal windows, so I'm 
# putting all customizations into bash_profile, even
# OS-specific things like colored 'ls' output because 
# I will rarely log in remotely to a local Mac machine.

alias ls='ls -Gh'
alias less='less -R'
alias more='more -R'
alias ll='ls -al'
alias llt='ls -alt'
alias subo='open -a sublime\ text'
alias stu='cd /Volumes/student/'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gl='git log'
alias gp='git push'
alias gpom='git push origin master'

# -W to highlight first unread line, +F to follow mode like tail -f
alias lesswf='less -W +F'

# add homebrew's more modern versions of installed unix utilities
#export PATH=/usr/local/bin:$PATH

# opt out of homebrew analytics
# https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
#export HOMEBREW_NO_ANALYTICS=1

# add directory colors to OS X shell
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# force colored output for 'less' to get color
export CLICOLOR_FORCE=1

# add unicode octopus to differentiate local prompt
# http://notes.torrez.org/2013/04/put-a-burger-in-your-shell.html
# export PS1="\w 🐙  "
export PS1="\W 🐙  "
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Bind Ctrl-R to reverse-search-history
# http://superuser.com/questions/419670/how-do-i-reload-inputrc-using-a-bash-script
# bind -f ~/.inputrc

# set window title BEFORE running commands
# http://stackoverflow.com/questions/5076127/bash-update-terminal-title-by-running-a-second-command
#trap 'echo -ne "\033]2;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG
