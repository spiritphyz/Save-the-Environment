## Create new terminfos using tic compiler
Compile the 2 files located in this same folder level.
  * [xterm terminfo](./xterm-256color-italic.terminfo)
  * [tmux terminfo](./tmux-256color.terminfo)

```bash
sudo tic -x xterm-256color-italic.terminfo
sudo tic -x tmux-256color.terminfo
```

## iTerm settings
May need to restart app to see changes.

* Preferences > Profiles > Terminal
  * Text > Text Rendering:
    * Enable: "Italic Text"
  * Report terminal type:
    * `xterm-256color-italic`

### Reference
* [How to get italics and true colors in Tmux and iTerm](https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be)
