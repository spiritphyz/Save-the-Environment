# Vim Buffers (files)
  * :ls    list buffers
  * :bd#   buffer destroy (:bd2 deletes buffer 2)
  * :o     open a file in same directory that you started Vim
  * :e     edit a file from any starting directory using file browser or FZF (ctrl-P)
  * C-g    show current filename

# Vim split panes
  * ctrl-w v    split into columns
  * ctrl-w s    split into stacks
  * ctrl-w |    zoom column split
  * ctrl-w _    zoom stack split
  * ctrl-w =    restore splits

  * ctrl-w l    move to left split
  * ctrl-w h    move to right split
  * ctrl-w j    move to bottom split
  * ctrl-w k    move to top split

  * resize-pane -L 10   resize current pane left by 10 cells
  * resize-pane -R 10   resize current pane right by 10 cells
  * resize-pane -U      resize current pane up
  * resize-pane -D      resize current pane down

# Reload .vimrc file while editing it inside Vim
  * :so %