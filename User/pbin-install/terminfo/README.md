## Create new terms using terminfo compiler
Compile the 2 files located in this same folder level.

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
* [How to get Italics and True Colors in Tmux and iTerm](https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be)
