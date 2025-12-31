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

" Use TokyoNight Neovim coiorscheme, supports Tree-sitter.
" Has 4 variants: Moon, Storm, Night, Day.
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Use fancy status bar, more lightweight than vim-airline
Plug 'itchyny/lightline.vim'

" Simulate a tab bar at top for open buffers
Plug 'mengelbrecht/lightline-bufferline'

" Show file explorer on left side, delay loading
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeToggle'] }

" Close braces in insert mode like Sublime, VSCode
" Press alt-p to toggle Auto Pairs
Plug 'LunarWatcher/auto-pairs'

" Paste and indent to match destination context
Plug 'sickill/vim-pasta'

" Allows syntax highlighting of CSS inside styled component template strings
" 2021-02-17: Project is unmaintained
" Needs to be before vim-polyglot or else breaks JavaScript indentation
" https://github.com/sheerun/vim-polyglot/issues/392#issuecomment-597891075
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Advanced grammar and syntax highlighting.
" Avoids vim's slow regex patterns for highlighting.
" 'do' updates parsers on plugin install.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" -- JSON helpers --
" allow front matter highlighting
Plug 'elzr/vim-json'

" -- Markdown helpers --
" For codefenced regions in CopilotChat. Use lazy loading.
Plug 'MeanderingProgrammer/render-markdown.nvim', { 'for': ['markdown', 'copilot-chat'] }

" -- Git helpers --
" ]c and [c to move between changed git chunks
Plug 'mhinz/vim-signify'      " Show symbols in gutter column, :SignifyHunkDiff
Plug 'tpope/vim-fugitive'     " Provides :Git commands, branch indicator

" Surround tag helper
Plug 'tpope/vim-surround'

" Automatically save sessions
" :Obsession              save session to 'Session.vim' to current folder
" :Obsession name.vim     save custom name for multiple sessions
" :source session.vim     reload session
Plug 'tpope/vim-obsession'

" Syntax-sensitive comment block helper
" gcc to toggle line comment
" gcip to toggle commenting out inner paragraph
Plug 'tpope/vim-commentary'

" HTML and CSS selector snippets
" Trigger completion with C-y,
" https://docs.emmet.io/cheat-sheet/
"
" Using coc-emmet for now, trigger completion with ctrl-e
Plug 'mattn/emmet-vim', { 'for': ['css', 'html', 'javascriptreact', 'typescriptreact'] }

" Intellisense Engine, uses VS Code's language servers
" Needs 'npm i -g neovim' and recent version of NodeJS
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Golang support
Plug 'fatih/vim-go', { 'for': 'go' }

" Angular language service
Plug 'iamcco/coc-angular'

" GraphQL queries: detect, syntax highlight, and indent
Plug 'jparise/vim-graphql'

" Show indent guides on all lines (including blank lines)
" lua branch is needed until Neovim 0.5 is released
" https://github.com/lukas-reineke/indent-blankline.nvim
Plug 'lukas-reineke/indent-blankline.nvim'

" Close buffers without closing or resetting window layout
Plug 'moll/vim-bbye'

" Keep project root consistent for current working directory
Plug 'airblade/vim-rooter'

" Helps work with CSV files
" https://github.com/chrisbra/csv.vim#using-a-plugin-manager
Plug 'chrisbra/csv.vim'

" Provides syntax highlighting for template literals in JavaScript
" Only works with tagged template string, like: html`<div>{{count}}</div>`
" Doesn't work with vscode es6-string-html plugin, like: /*html*/`
Plug 'Quramy/vim-js-pretty-template'

" Comment out line based on context with: gcc
" Can do these comments correctly in VueJS templates, React:
" /* CSS */ ..... // JS ..... <!-- HTML -->
" Requires TreeSitter
" Needs another mapping plugin like vim-commentary (above)
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Highlight matching words, extends Vim % key
Plug 'andymass/vim-matchup'

" Autoclose and autorename HTML tags using TreeSitter syntax
Plug 'windwp/nvim-ts-autotag'

" Provide 'sticky scroll', showing enclosing function at top
Plug 'nvim-treesitter/nvim-treesitter-context'

" Use AI completions
" Needs g:copilot_proxy_strict_ssl = v:false in init.vim.
" Also needs NODE_TLS_REJECT_UNAUTHORIZED=0 in ~/.zshrc.
" See --> :help g:copilot_proxy_strict_ssl
"
" To disable virtual text and rely on coc-copilot panel, needs hack in:
" ~/.local/share/nvim/plugged/copilot.vim/autoload/copilot.vim
" See -> https://github.com/hexh250786313/coc-copilot/issues/12
"
" Run :Copilot setup to authenticate on first install.
" Plug 'github/copilot.vim'
" Ensure Copilot itself is lazy-loaded.
Plug 'github/copilot.vim', { 'on': 'Copilot' }

" Chat with Copilot in Neovim
" For more accurate token counts, install tiktoken.
" Install Lua 5.1 --> brew install luajit
" Install luarocks --> brew install luarocks
" Non-sudo home install --> luarocks install --lua-version 5.1 tiktoken_core
" cp ~/.luarocks/lib/lua/5.1/tiktoken_core.so /usr/local/lib/lua/5.1/
" checkhealth CopilotChat --> OK tiktoken_core: installed
Plug 'nvim-lua/plenary.nvim'
" Make vim-plug avoid adding CopilotChat to runtimepath on app start.
" Only load plugin on first run of any of the listed commands.
Plug 'CopilotC-Nvim/CopilotChat.nvim',
      " 'canary' is the experimental branch.
      " \ { 'branch': 'canary', 'on': [
      \ { 'branch': 'main', 'on': [
      \   'CopilotChat',
      \   'CopilotChatToggle',
      \   'CopilotChatExplain',
      \   'CopilotChatReview',
      \   'CopilotChatFix',
      \   'CopilotChatDocs',
      \   'CopilotChatTests'
      \ ] }

" Toggle full-pane windows like Tmux
" Use C-w m to toggle. Provides zoom#statusline() API
" Plug 'dhruvasagar/vim-zoom'

" FZF fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Restore unnamed buffers like Sublime, Notepad++
" Doesn't seem to have much utlity right now
" Plug 'abdalrahman-ali/vim-remembers'

" Syntax highlighting for PHP Blade templates
Plug 'jwalton512/vim-blade'

" Allows fancy icon glyphs in lightline tabs and NERDTree.
" Should be loaded as last plugin.
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()
