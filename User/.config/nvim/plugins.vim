" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" Check if vim-plug is installed, otherwise install it
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

call plug#begin('~/.local/share/nvim/plugged')

"Plug 'pangloss/vim-javascript'
"Plug 'crusoexia/vim-javascript-lib'
Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'scrooloose/nerdtree'
"Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Syntax highlighting for many languages
Plug 'sheerun/vim-polyglot'

" JSON helpers
" allow front matter highlighting
Plug 'elzr/vim-json'
" allows table formatting in Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" HTML and CSS selector snippets
" https://docs.emmet.io/cheat-sheet/
Plug 'mattn/emmet-vim'

" Surround tag helper
Plug 'tpope/vim-surround'

" Intellisense Engine, uses VS Code's language servers
" Needs 'npm i -g neovim' and recent version of NodeJS
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}

" Golang support
Plug 'fatih/vim-go'

" Allows fancy icons in lightline tabs and NERDTree.
" Should be loaded as last plugin.
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()
