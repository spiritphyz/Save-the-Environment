# Vim Buffers (files)
  * :ls       list buffers
  * :b1       switch to buffer 1
  * :bu frag  switch to buffer by searching fragment of name
  * :bd#      buffer destroy (:bd2 deletes buffer 2)
  * :e        edit a file in same directory that you started Vim
  * :o        open a file from any starting directory using file browser or               FZF (ctrl-P)
  * C-g       show current filename

# Vim Windows (split panes)
  * ctrl-w v or :vsp    split into columns
  * ctrl-w s or :sp     split into stacks
  * ctrl-w |            zoom column split
  * ctrl-w _            zoom stack split
  * ctrl-w =            restore splits equally
  * ctrl-w o or :on     cancel split pane (make it the "only" split)

  * ctrl-w l            focus on left split
  * ctrl-w h            focus on right split
  * ctrl-w j            focus on bottom split
  * ctrl-w k            focus on top split

  * ctrl-w R            swap top/bottom or left/right split

  * ctrl-w -            resize height shorter by 1 unit
  * ctrl-w +            resize height taller by 1 unit
  * :res +5             resize height taller by 5 units
  * :res -5             resize height shorter by 5 units

  * ctrl-w >            resize width wider by 1 unit
  * ctrl-w <            resize width thinner by 1 unit
  * :vert res +5        resize width wider by 5 units
  * :vert res -5        resize width thinner by 5 units

# Reload .vimrc file while editing it inside Vim
  * :so %

# Vim marks
  * m1                  set mark named "1"
  * '1                  jump to mark named "1"
  * mH                  set capitalized mark named "H"
  * :bH                 jump to named buffer across any open buffers,
                        useful if you set "H" for Header file, "C" for
                        a source file, "M" for Makefile

