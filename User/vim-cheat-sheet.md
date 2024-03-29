# Vim buffers (files)
```
:ls       list buffers
:b1       switch to buffer 1
:bu frag  switch to buffer by searching fragment of name
:bd       buffer delete (unload current buffer)
:bd#      buffer delete numbered buffer 2
:e file   edit a file in same directory that you started Vim
:e!       reload file from disk, discard changes
:o        open file from any starting directory using file browser or FZF (ctrl-P)
C-g       show current filename
:ene      edit new empty buffer
```

# Normal mode shortcuts
```
xp           swap (transpose) current character with next character
Xp           transpose current character with previous character
~            toggle uppercase or lowercase for current character
ctrl-o       jump to older location in jump list
ctrl-i       jump to newer location in jump list
:jumps       show jump list. keeps track of file, line, and column position
ctrl-^       (or sometimes ctrl-6): jump back and forth between last buffers
!            run an arbitrary command, like: ! ls -alF
q:           open command history search, press Enter to execute curr line
"ay{motion}  copy (yank) text into named register 'a'
"ap          paste text from named register 'a'
shift-<<     shift current line left
shift->>     shift current line right
gq           reformat paragraph to word wrap textwidth
```

# Insert mode shortcuts
:help ins-special-keys
  * ctrl-d              move backwards one tab stop
  * ctrl-t              move forwards one tab stop
  * ctrl-h              delete character before
  * ctrl-w              delete word before
  * ctrl-u              delete to beginning
  * ctrl-o D            delete to end
  * ctrl-n              invoke next autocomplete
  * ctrl-p              invoke prev autocomplete
  * ctrl-j              insert new line
  * ctrl-t              indent current line
  * ctrl-d              un-indent current line
  * ctrl-[              quit Insert mode, switch to Normal mode
  * ctrl-c              quit Insert mode, switch to Normal mode
  * ctrl-o              do one command without leaving Insert mode
  * ctrl-o l            move cursor right
  * ctrl-o h            move cursor left
  * shift-right         move cursor one word right
  * shift-left          move cursor one word left

# Visual mode shortcuts
  * <                       shift selection left
  * >                       shift selection right
  * ctri-V, ctrl-I, motion  blockwise edit, like add line number

# Incrementing numbers
For Vim 8+, have a bunch lines with the same number pattern, like:
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;
my_array[00] = 0;

Press ctrl-v on first 0 to start a blockwise select, then select the second 0, then move down towards the end. To automatically number the selection, press g ctrl-a
my_array[01] = 0;
my_array[02] = 0;
my_array[03] = 0;
my_array[04] = 0;
my_array[05] = 0;
my_array[06] = 0;
my_array[07] = 0;
my_array[08] = 0;
my_array[09] = 0;
my_array[10] = 0;
my_array[11] = 0;


# Vim Windows (split panes)
  * ctrl-w v or :vsp    split into columns
  * ctrl-w s or :sp     split into stacks
  * ctrl-w c            close current window (pane)
  * ctrl-w |            zoom column split (shows other panes as skinny split)
  * ctrl-w _            zoom stack split  (shows other panes as skinny split)
  * ctrl-w =            reset splits with equal spacing
  * ctrl-w o or :on     cancel split pane (make it the "only" split)
  * :q                  close split pane

  * ctrl-w l            focus on left split
  * ctrl-w h            focus on right split
  * ctrl-w j            focus on bottom split
  * ctrl-w k            focus on top split

  * ctrl-w R            swap top/bottom or left/right split (rotate right)
  * ctrl-w J            swap top/bottom
  * ctrl-w K            swap top/bottom
  * ctrl-w H            swap left/right
  * ctrl-w L            swap left/right

  * ctrl-w -            resize height shorter by 1 unit
  * ctrl-w +            resize height taller by 1 unit
  * :res +5             resize height taller by 5 units
  * :res -5             resize height shorter by 5 units

  * ctrl-w >            resize width wider by 1 unit
  * ctrl-w <            resize width thinner by 1 unit
  * :vert res +5        resize width wider by 5 units
  * :vert res -5        resize width thinner by 5 units
  * (drag mouse)        grab the split line and resize the pane

# Scrolling the view
These commands are affected by 'scrolloff' value.
  * zt                  position current line at top of view
  * zz or z.            position current line at middle
  * zb or z-            position current line at bottom
  * ctrl-e              move screen down 1 line unless cursor in viewport
  * ctrl-y              move screen up 1 line unless cursor in viewport

# Reload .vimrc file while editing it inside Vim
  * :so %

# Search with * and #
  * #                   set word to search for backwards
  * * or g*             with current word, jump to next occurrence
  * # or g#             with current word, jump to prev occurrence
  * n                   move to next occurrence
  * N                   move to prev occurrence
  * n                   move backwards to next occurrence
  * N                   move backwards to prev occurrence
  * g*                  search for not exact word forwards
  * g#                  search for not exact word backwards
  * :set ic             enable case-insensitive search
  * :set noic           disable case-insentitive search

# Search inside a line
  * fe                  find forward next 'e' character
  * Fe                  find backward next 'e' character
  * te                  jump to character before the next 'e' (unTil)
  * Te                  jump to character before the previous 'e'
  * ;                   move to next occurrence in line
  * ,                   move to previous occurrence in line

# Vim marks
  * ma                  set mark named 'a', local to 1 buffer
  * 'a                  jump to mark named 'a' (first non-blank character)
  * `a`                 jump to mark named 'a' (exact character)
  * mH                  set capitalized mark named `H`, global to all buffers
  * 'H                  jump to named buffer across any open buffers,
                        useful if you set "H" for Header file, "C" for
                        a source file, "M" for Makefile

# Autocompletion
  * ctrl-x ctrl-f       autocomplete path in insert mode
  * ctrl-n or ctrl-p    move up or down in the dropdown menu

# Ex commands
  * :pwd                print working directory
  * :s/foo/bar/g        for curr line, replace foo w/ bar for all occurrences
  * :%s/foo/bar         for all lines, replace foo w/ bar
  * :set syntax=html    set syntax highlighting for current buffer
  * :set cc=80          short version of "set colorcolumn=80" for vertical guide
  * :retab              convert tabs to spaces using settings in .vimrc

# Spell check
  * ]s                  go to next misspelled word
  * [s                  go to prev misspelled word
  * z=                  with cursor on misspelled word, show suggestions
  * 1z=                 accept first spelling suggestion
  * zw                  mark word as misspelled
  * zug                 undo mark word as misspelled
  * zg                  with misspelled word, add to dictionary
  * zug                 undo add word to spellfile
  * :set nospell        turn off highlighting
