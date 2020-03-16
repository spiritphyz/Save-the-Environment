# Save the Environment 🌏
Let's save our settings for a better future.
  * Neovim
  * Vim
  * Visual Studio Code
  * Sublime Text


# File Locations
| Repository Path                    | Destination on Your Computer        |
| :--------------------------------- | :---------------------------------- |
| User/.eslintrc.json                | ~/.eslintrc.json                    |
| User/.tmux.conf                    | ~/.tmux.conf                        |
| User/.tmux.conf.tmux28macOS        | /User/yourusername/.tmux.conf       |
| User/.config/nvim                  | ~/.config/nvim                      |
| User/.vim                          | ~/.vim                              |
| User/.vimrc                        | ~/.vimrc                            |
| User/pbin/z.sh                     | ~/pbin/z.sh                         |


# Create Directories
 * ~/.nvim/backup
 * ~/.nvim/swap
 * ~/.nvim/undo

# Install Utilities
```bash
# Install eslint for nvim coc-eslint
npm i -g eslint

# Install Python virtualenv
pip install neovim

# Install NodeJS provider
npm i -g neovim

# Install ripgrep on macOS
# Ubuntu instructions are here:
# https://github.com/BurntSushi/ripgrep#installation
brew install ripgrep

# Install FZF and Silver Surfer on Linux or macOS
sudo apt install fzf
brew install fzf
sudo apt install silversearcher-ag
brew install the_silver_searcher

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

# Install Prettier for JavaScript
Run ":CocInstall coc-prettier" inside Neovim
```
