" ============================================================================ "
" ===                           PLUGIN                                     === "
" ============================================================================ "

" === vim-plug options ===
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

" Put plugins here
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'                              " allows table formatting in Markdown
Plug 'elzr/vim-json'                                  " allow front matter highlighting
Plug 'plasticboy/vim-markdown'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'
Plug 'tpope/vim-surround'
Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'scrooloose/nerdtree'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}
Plug 'ryanoasis/vim-devicons'                         " should be loaded as last plugin

" Initialize plugin system
call plug#end()
