## Create new terminfo database entries using tic compiler
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
    * `xterm-256color` seems to work fine, too

### Reference
* [How to get italics and true colors in Tmux and iTerm](https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be)
* [Italics in iTerm2, Tmux, and SSH](https://weibeld.net/terminals-and-shells/italics.html)
