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

Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'scrooloose/nerdtree'

" Close braces in insert mode like Sublime, VSCode
" Press alt-p to toggle Auto Pairs
Plug 'jiangmiao/auto-pairs'

" Syntax highlighting for many languages
let g:polyglot_disabled = ['md', 'markdown'] " interferes with vim-markdown
Plug 'sheerun/vim-polyglot'

" JSON helpers
Plug 'elzr/vim-json'             " allow front matter highlighting

" Markdown helpers
Plug 'godlygeek/tabular', { 'for': 'markdown' }   " allows table formatting
"Plug 'plasticboy/vim-markdown'                   " disable, breaks vim-one
Plug 'gabrielelana/vim-markdown'                  " doesn't have code folding

" Git helpers
" ]c and [c to move between changed git chunks
Plug 'mhinz/vim-signify'         " Show symbol in gutter, :SignifyHunkDiff
Plug 'tpope/vim-fugitive'        " Provides :Git commands, branch indicator

" Live preview in browser with :MarkdownPreview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'], 'on': 'MarkdownPreview' }

" Surround tag helper
Plug 'tpope/vim-surround'

" Automatically save sessions
Plug 'tpope/vim-obsession'

" Syntax-sensitive comment block helper
" gcc to toggle line comment
" gcip to toggle commenting out inner paragraph
Plug 'tpope/vim-commentary'

" Snippet support
" In insert mode, type snippet, then ctrl-k
" In command mode, ctrl-k is navigate to lower Vim split
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" HTML and CSS selector snippets
" Trigger completion with C-y,
" https://docs.emmet.io/cheat-sheet/
Plug 'mattn/emmet-vim', { 'for': ['css', 'html', 'javascriptreact', 'typescriptreact'] }

" Allows syntax highlighting of CSS inside styled component template strings
" 2021-02-17: Project is unmaintained
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Denite - Fuzzy finding, buffer management
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

" Intellisense Engine, uses VS Code's language servers
" Needs 'npm i -g neovim' and recent version of NodeJS
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" These plugins will automatically be installed and updated by CoC
" :CocInstall to install the first time
" :CocUpdate to update the plugins
let g:coc_global_extensions = [
  \ 'coc-prettier',
  \ 'coc-python',
  \ 'coc-tsserver'
  \ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Golang support
Plug 'fatih/vim-go', { 'for': 'markdown' }

" Angular language service
Plug 'iamcco/coc-angular'

" GraphQL queries: detect, syntax highlight, and indent
Plug 'jparise/vim-graphql'

" Allows fancy icons in lightline tabs and NERDTree.
" Should be loaded as last plugin.
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()
