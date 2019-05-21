# Vim Buffers (files)
  * :ls    list buffers
  * :bd#   buffer destroy (:bd2 deletes buffer 2)
  * :o     open a file in same directory that you started Vim
  * :e     edit a file from any starting directory using file browser or FZF (ctrl-P)
  * C-g    show current filename

# Vim windows (split panes)
  * ctrl-w v    split into columns
  * ctrl-w s    split into stacks
  * ctrl-w |    zoom column split
  * ctrl-w _    zoom stack split
  * ctrl-w =    restore splits equally

  * ctrl-w l    focus on left split
  * ctrl-w h    focus on right split
  * ctrl-w j    focus on bottom split
  * ctrl-w k    focus on top split
      
  * ctrl-w -         resize height shorter by 1 unit
  * ctrl-w +         resize height taller by 1 unit
  * :res +5          resize height taller by 5 units
  * :res -5          resize height shorter by 5 units

  * ctrl-w >         resize width wider by 1 unit
  * ctrl-w <         resize width wider by 1 unit
  * :vert res +5     resize width wider by 5 units
  * :vert res -5     resize width thinner by 5 units

# Reload .vimrc file while editing it inside Vim
  * :so %
