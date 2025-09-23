# Terminal aliases
# show human-readable file sizes, show color
#alias ls='ls -h --color'  # Linux
alias ls='ls -hG'         # macOS
alias ll='ls -al'
alias lll='ls -al --color | less -R' # get color in less piping
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
alias griph='f(){ FLASK_ENV=development grip "$1" 0.0.0.0:9090; unset -f f; }; f' # public access on port 9090

# Git-specific aliases
alias gs='git status'
alias gslm='git status -s | while read mode file; do echo $mode $(stat -f "%Sm" $file) $file; done|sort'
alias gsc='git show $1'                          # put in commit ID for $1
alias ga='git add'
alias gd='git diff'
alias gdc='git diff --color-words=.'             # highlight individual color changes
alias gc='git commit'
alias gl='git log'
alias gll='git log --graph --decorate --pretty=oneline --abbrev-commit --all'
alias gls='git log --stat'
alias gp='git push'
alias gpom='git push origin main'
alias gcm='git commit -m'
alias gb='git branch'
alias gbsrcd='git branch --sort=-committerdate'  # descending
alias bd='batdiff'
alias grb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:iso8601) %(refname:short)'"
# gitblamelike: 'git log --pretty=short -u -L 451,457:themes/misp/wizard/src/components/Home.vue'
alias gitblamelike='git log --pretty=short -u -L $1:$2' # provide line number range '451,457', then path to filename
