# Terminal aliases
alias ls='ls -h' # show human-readable file sizes
alias ll='ls -al'
alias lll='ls -alF --color | less -R' # get color in less piping
alias lsrt='ls -rt'

alias less='less -R' # help maintain color control characters
alias more='more -R' # help maintain color control characters

# macOS-specific
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias subo='open -a sublime\ text'
alias cdi='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'

# Git-specific aliases
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gdc='git diff --color-words=.' # highlight individual color changes
alias gc='git commit'
alias gl='git log'
alias gll='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias gp='git push'
alias gpom='git push origin master'
alias gcm='git commit -m'
