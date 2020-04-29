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

" Close braces in insert mode like Sublime, VSCode
Plug 'jiangmiao/auto-pairs'

" Syntax highlighting for many languages
Plug 'sheerun/vim-polyglot'

" JSON helpers
Plug 'elzr/vim-json'             " allow front matter highlighting

" Markdown helpers
Plug 'godlygeek/tabular'         " allows table formatting in Markdown
"Plug 'plasticboy/vim-markdown'  " broken, not compatible with vim-one
Plug 'gabrielelana/vim-markdown' " doesn't have code folding

" Git helpers
Plug 'mhinz/vim-signify'         " Show symbol in gutter, :SignifyHunkDiff
Plug 'tpope/vim-fugitive'        " Provides :Git commands, branch indicator

" Live preview in browser with :MarkdownPreview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install' }

" Surround tag helper
Plug 'tpope/vim-surround'

" HTML and CSS selector snippets
" https://docs.emmet.io/cheat-sheet/
Plug 'mattn/emmet-vim'

" Denite - Fuzzy finding, buffer management
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

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
