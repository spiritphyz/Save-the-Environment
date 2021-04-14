# Terminal aliases
# show human-readable file sizes, show directory symbols, show color
#alias ls='ls -hF --color'  # Linux
alias ls='ls -hFG'         # macOS
alias ll='ls -al'
alias lll='ls -alF --color | less -R' # get color in less piping
alias lsrt='ls -rt'

alias less='less -R' # help maintain color control characters
alias more='more -R' # help maintain color control characters

# macOS-specific
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias subo='open -a sublime\ text'
alias cdi='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias nv='/usr/local/bin/nvim'
alias kode='cd ~/kode'
alias stx="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep 'lastTxRate'"

# Grip-specific
# Bash aliases only accept arguments at the end, not in the middle,
# so we have to use a temporary function 'f' and unset it
# https://stackoverflow.com/a/42466441
alias griph='f(){ FLASK_ENV=development grip "$1" 0.0.0.0:8090; unset -f f; }; f' # public access on port 8090

# Git-specific aliases
alias gs='git status'
alias gss='git show $1'              # put in commit ID for $1
alias ga='git add'
alias gd='git diff'
alias gdc='git diff --color-words=.' # highlight individual color changes
alias gc='git commit'
alias gl='git log'
alias gll='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias gls='git log --stat'
alias gp='git push'
alias gpom='git push origin main'
alias gcm='git commit -m'
