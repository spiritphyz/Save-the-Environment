# Save the Environment 🌏
Let's save our settings for a better future.
  * Neovim
  * Vim
  * Visual Studio Code
  * Sublime Text
  * Alacritty


# File Locations
| Repository Path                    | Destination on Your Computer        |
| :--------------------------------- | :---------------------------------- |
| User/.eslintrc.json                | ~/.eslintrc.json                    |
| User/.tmux.conf                    | ~/.tmux.conf                        |
| User/.tmux.conf.tmux28macOS        | /User/yourusername/.tmux.conf       |
| User/.config/nvim                  | ~/.config/nvim                      |
| User/.config/alacritty             | ~/.config/alacritty                 |
| User/.vim                          | ~/.vim                              |
| User/.vimrc                        | ~/.vimrc                            |
| User/pbin/z.sh                     | ~/pbin/z.sh                         |


# Create Directories
 * ~/.config/nvim/snippets
 * ~/.nvim/backup
 * ~/.nvim/swap
 * ~/.nvim/undo

# Set up Tmux plugins
 ```bash
mkdir -p ~/.tmux/plugins/tpm
mkdir -p ~/.tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
 ```

# Install Neovim and CoC
Install nightly version:
https://github.com/neovim/neovim/releases/tag/nightly

If you get CoC errors about a frozen lock file, then run the yarn install manually:
```bash
cd /Users/yourusername/.local/share/nvim/plugged/coc.nvim
yarn install --frozen-lockfile
```

# Install Utilities
```bash
# Install eslint for nvim coc-eslint
npm i -g eslint

# Install Python virtualenv
pip3 install neovim

# Install Neovim Python module
pip3 install pynvim

# Install NodeJS provider
npm i -g neovim

# Install ripgrep on macOS
# Ubuntu instructions are here:
# https://github.com/BurntSushi/ripgrep#installation
brew install ripgrep

# Install FZF on Linux
# Fuzzy auto-completion and Neovim plugin installed automatically it seems
sudo apt install fzf

# FZF on macOS
brew install fzf
$(brew --prefix)/opt/fzf/install

# Run ":checkhealth" inside Neovim

# Run ":UpdateRemotePlugins" inside Neovim for Denite

# Install x86_64-linux-gnu-gcc compiler, needed for pylint
sudo apt install python3-dev

# Install elevated linter for Neovim virtual environment
sudo pip3 install pylint
```
# Install CoC extensions manually
 You can use a Neovim plugin manager, but there are [bad limitations](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#use-vims-plugin-manager-for-coc-extension):
  - Plugin won't be automatically updated
  - You can't use `:CocUninstall`

We need to install the CoC extensions manually:
```bash
# Install Python IntelliSense
Run ":CocInstall coc-python" inside Neovim

# Install vscode-eslint support
Run ":CocInstall coc-eslint" inside Neovim

# Install Prettier for JavaScript
Run ":CocInstall coc-prettier" inside Neovim
```
# Alacritty, Neovim and italics for comments

1. Add Alacritty [terminal support for italics](https://github.com/alacritty/alacritty/blob/master/INSTALL.md#terminfo).

```bash
# Check if alacritty terminfo is not empty
infocmp alacritty

# If empty, download the helper file
curl -O https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info

# Install the alacritty terminal type globally using the helper file
sudo tic -xe alacritty,alacritty-direct alacritty.info
```

2. Make sure the font you're using has an italic weight, for example:
```
Hack Nerd Font
  Regular
  Italic
  Bold
```

3. Set `~/.config/alacritty/alacritty.yml` to use font family.
```yaml
font:
  normal:
    family: Hack Nerd Font
```

4. Make sure these lines are in `~/.config/nvim/init.vim`:
```vim
" Italicize inline comments, set after colorscheme and one#highlight
highlight Comment cterm=italic gui=italic
" Italicize whole line comments
highlight vimLineComment cterm=italic gui=italic
```
