# Tmux Sessions
  * C-b :new   create new session
  * C-b $      rename current session
  * C-b )      switch to next session
  * C-b (      switch to previous session
  * C-b s      show all sessions (lower-case s)

# Tmux Windows (tabs)
  * C-b c    create window
  * C-b 1    switch to window 1
  * C-b w    list windows
  * C-b n    next window
  * C-b p    previous window // conflicts with my Tmux paste
  * C-b ,    name window
  * C-b .    move window (prompts for new window index)
  * C-b &    kill window

  * :swap-window -s 3 -t 2   swap window 2 and target window 3

# Tmux Panes (splits)
M is the meta key, which is `option` on Mac keyboards.
`C-b M-1` means to "press control-b, then press option-1".

  * C-b %    create left & right panes (slash symbol is mostly horizontal)
  * C-b "    create top & bottom panes (double quote is above single quote)
  * C-b o    jump between panes
  * C-b q2   show pane numbers, jump to pane 2
  * C-b ;    move cursor to last active pane
  * C-b o    move cursor to last active pane (other)
  * C-b }    move current pane to right
  * C-b {    move current pane to left
  * C-b x    close pane // conflicts with my Tmux prefix
  * C-b :kill-pane      kill pane

  * resize-pane -L 10   resize current pane left by 10 cells
  * resize-pane -R 10   resize current pane right by 10 cells
  * resize-pane -U      resize current pane up
  * resize-pane -D      resize current pane down
  * C-b M-arrow_key     resize the active pane

  * C-b M-1        split columns, equal width
  * C-b M-2        stack vertically, equal height
  * C-b M-3        big pane on top, split columns on bottom
  * C-b M-4        big pane on left, split columns on right
  * C-b M-5        big pane on bottom, split columns on top
  * C-b spacebar   cycle through pane layouts (equal parts)
  * C-b !          convert pane into a window

  * :swap-panes -s 3 -t 2   swap source pane 2 and target pane 3
  * :select-layout tiled    make all splits roughly equal

  & C-b t         show big clock

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
| `:show-buffer`                     | show buffer_0 contents                       |
| `:list-buffer`                     | list all buffers                             |
| `:choose-buffer`                   | show all buffers and paste selected one      |
| `:capture-pane`                    | copy visual content into buffer              |
| `:save-buffer name.txt`            | save buffer content to a file                |


# Tmux configuration file
* C-b :source-file ~/.tmux.conf     reload config file

# Tmux resurrect plugin
 * C-b C-s              save session
 * C-b C-r              restore session
 * C-b :kill-server     kill server to test restores
