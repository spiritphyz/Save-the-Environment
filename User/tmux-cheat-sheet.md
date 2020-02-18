# Tmux Sessions
  * C-b $  rename current session
  * C-b )  switch to next session
  * C-b (  switch to previous session

# Tmux Windows (tabs)
  * C-b c  create window
  * C-b 1  switch to window 1
  * C-b w  list windows
  * C-b n  next window
  * C-b p  previous window // interferes with tmux paste
  * C-b ,  name window
  * C-b .  move window (prompts for new window index)
  * C-b &  kill window

# Tmux Panes (splits)
M is the meta key, which is `option` on Mac keyboards.

`C-b M-1` means to "press control-b, then press option-1".

  * C-b %    split into left and right panes (percent symbol parts are mostly horizontal)
  * C-b "    split into top and bottom panes (double quote is stacked above single quote)
  * C-b o    jump between panes
  * C-b q2   show pane numbers, jump to pane 2
  * C-b C-b  swap the location of 2 panes
  * C-b }    move current pane to right
  * C-b {    move current pane to left

  * C-b M-1  split columns, equal width
  * C-b M-2  stack vertically, equal height
  * C-b M-3  big pane on top, split columns on bottom
  * C-b M-4  big pane on left, split columns on right
  * C-b M-5  big pane on bottom, split columns on top

  * resize-pane -L 10   resize current pane left by 10 cells
  * resize-pane -R 10   resize current pane right by 10 cells
  * resize-pane -U      resize current pane up
  * resize-pane -D      resize current pane down
  * C-b M-arrow_key     resize the active pane

  * :select-layout tiled  make all splits roughly equal

# Tmux copy and paste
`C-b p` means to "press control-b, then press p".

| Sequence                           | Description                                  |
|:---------------------------------- |:-------------------------------------------- |
| `(click and drag to select text)`  | copy selected text to Tmux clipboard         |
| `C-b p`                            | paste text from Tmux clipboard               |
| `(option-click and drag)`          | copy selected text to iTerm clipboard        |
| `Cmd-v`                            | paste text from iTerm clipboard              |
| `C-b [`                            | enter Copy Mode, use vi keys to move around  |
| `y` on selection in Copy Mode      | yank selection to Tmux clipboard             |
| `(enter key)` in Copy Mode         | exit Copy Mode                               |
