# Tmux Sessions
  * C-b $  rename current session
  * C-b )  switch to next session
  * C-b (  switch to previous session

# Tmux Windows (tabs)
  * C-b c  create window
  * C-b w  list windows
  * C-b n  next window
  * C-b p  previous window
  * C-b ,  name window
  * C-b &  kill window

# Tmux Panes (splits)
M is the meta key, which is `option` on Mac keyboards.

`C-b M-1` means to "press control-b, then press option-1".

  * C-b %    split into left and right panes (percent symbol parts are mostly horizontal)
  * C-b "    split into top and bottom panes (double quote is stacked above single quote)
  * C-b o    jump between panes
  * C-b C-b  swap the location of 2 panes
  * C-b }    move current pane to right
  * C-b {    move current pane to left
 
  * C-b M-1  split columns, equal width
  * C-b M-2  stack vertically, equal height
  * C-b M-3  main pane on top, column splits on bottom
  * C-b M-4  main pane on left, stack remaining splits
  * C-b M-4  new pane on bottom, split columns on top

  * :select-layout tiled  make all splits roughly equal

# Tmux copy and paste
`C-b p` means to "press control-b, then press p".

| Sequence                           | Description                                  |
|:---------------------------------- |:-------------------------------------------- |
| `(click and drag to select text)`  | copy selected text to Tmux clipboard         |
| `C-b p`                            | paste highlighted text                       |
| `(option-click and drag)`          | copy selected text to iTerm clipboard        |
| `Cmd-v`                            | paste text from iTerm clipboard              |
| `C-b [`                            | enter Copy Mode, use vi keys to move around  |
| `y` on selection in Copy Mode      | yank selection to Tmux clipboard             |
| `(enter key)` in Copy Mode         | exit Copy Mode                               |
