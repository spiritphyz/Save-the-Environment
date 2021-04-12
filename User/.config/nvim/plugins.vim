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

" Use Atom One Dark theme for colorscheme
Plug 'rakr/vim-one'

" Use fancy status bar, more lightweight than vim-airline
Plug 'itchyny/lightline.vim'

" Simulate a tab bar at top for open buffers
Plug 'mengelbrecht/lightline-bufferline'

" Show file explorer on left side
Plug 'scrooloose/nerdtree'

" Close braces in insert mode like Sublime, VSCode
" Press alt-p to toggle Auto Pairs
Plug 'jiangmiao/auto-pairs'

" Paste and indent to match destination context
Plug 'sickill/vim-pasta'

" Allows syntax highlighting of CSS inside styled component template strings
" 2021-02-17: Project is unmaintained
" Needs to be before vim-polyglot or else breaks JavaScript indentation
" https://github.com/sheerun/vim-polyglot/issues/392#issuecomment-597891075
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Syntax highlighting for many languages
" Must configure polyglot options before loading plugin
" Disable polyglot for markdown, interferes with vim-markdown
let g:polyglot_disabled = ['md', 'markdown']
Plug 'sheerun/vim-polyglot'

" More advanced syntax highlighting
" Doesn't seem to support JSX yet (2021-04-11), see open issues for 'jsx'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" -- JSON helpers --
" allow front matter highlighting
Plug 'elzr/vim-json'

" -- Markdown helpers --
Plug 'godlygeek/tabular', { 'for': 'markdown' }   " allows table formatting
"Plug 'plasticboy/vim-markdown'                   " disable, breaks vim-one
Plug 'gabrielelana/vim-markdown'                  " doesn't have code folding

" -- Git helpers --
" ]c and [c to move between changed git chunks
Plug 'mhinz/vim-signify'      " Show symbols in gutter column, :SignifyHunkDiff
Plug 'tpope/vim-fugitive'     " Provides :Git commands, branch indicator

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

" Denite - Fuzzy finding, buffer management
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

" Intellisense Engine, uses VS Code's language servers
" Needs 'npm i -g neovim' and recent version of NodeJS
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Golang support
Plug 'fatih/vim-go', { 'for': 'markdown' }

" Angular language service
Plug 'iamcco/coc-angular'

" GraphQL queries: detect, syntax highlight, and indent
Plug 'jparise/vim-graphql'

" Show indent guides on all lines (including blank lines)
" lua branch is needed until Neovim 0.5 is released
" https://github.com/lukas-reineke/indent-blankline.nvim
Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }

" Allows fancy icon glyphs in lightline tabs and NERDTree.
" Should be loaded as last plugin.
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()
