# Problem
Outside Tmux, the delete key behaves normally and directory listing colors are shown.

Inside Tmux, the delete key produces spaces and directory listing colors are shown without color.

# Fix
 * https://github.com/tmux/tmux/issues/1257#issuecomment-581378716

 ```sh
brew install ncurses

/usr/local/opt/ncurses/bin/infocmp tmux-256color > ~/tmux-256color.info

# This creates a compiled entry in ~/.terminfo
tic -xe tmux-256color tmux-256color.info

infocmp tmux-256color | head

# Reconstructed via infocmp from file: /Users/libin/.terminfo/74/tmux-256color
# tmux-256color|tmux with 256 colors,
# etc.
 ```
