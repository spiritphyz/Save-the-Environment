" ============================================================================ "
" ===                           ENCODING                                   === "
" ============================================================================ "

" Use Unicode characters. Should be at the top of the file.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif


" ============================================================================ "
" ===                              PLUGINS                                 === "
" ============================================================================ "

" Install vim-plug if not present:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" Status bar
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" File explorer
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeToggle'] }

" Auto close brackets
Plug 'LunarWatcher/auto-pairs'

" Git helpers
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

" Tim Pope essentials
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-commentary'

" Close buffers without disrupting layout
Plug 'moll/vim-bbye'

" Keep project root consistent
Plug 'airblade/vim-rooter'

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Colorscheme: one dark (Vim-compatible alternative to tokyonight)
Plug 'rakr/vim-one'

" JSON
Plug 'elzr/vim-json'

" GraphQL
Plug 'jparise/vim-graphql'

" PHP Blade
Plug 'jwalton512/vim-blade'

" CSV
Plug 'chrisbra/csv.vim'

" Fancy icons (load last)
Plug 'ryanoasis/vim-devicons'

call plug#end()


" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Yank and paste with the system clipboard
set clipboard=unnamed

" Disable auto comments on new lines
set formatoptions-=cro

" Toggle search highlighting with '\'
nnoremap \ <Esc>:set hls!<CR>

" Remove search highlighting when entering insert mode
autocmd InsertEnter * :let @/=""

" Tab key behavior
set noexpandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

" Word wrapping
set wrap
set linebreak
set formatoptions+=1

" Filetype detection and indentation
filetype on
filetype plugin on
filetype indent on

" OmniCompletion
" Use ctrl-n for Vim's built-in completion.
" Use ctrl-x, ctrl-o for filetype-specific completion when available.
set omnifunc=syntaxcomplete#Complete

" Backspace over line breaks
set backspace=indent,eol,start

" Folds: open all by default
autocmd BufReadPost,FileReadPost * normal zR
set nofoldenable

" PHP filetype
autocmd BufNewFile,BufRead *.php set filetype=php


" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

" === Lightline ===
set laststatus=2

function! LightlineFilename()
  let shortfilename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''

  let name = ""
  let subs = split(expand('%'), "/")
  let i = 1
  for s in subs
    let parent = name
    if  i == len(subs)
      let name = parent . '/' . s
    elseif i == 1
      let name = s
    else
      let name = parent . '/' . strpart(s, 0, 5)
    endif
    let i += 1
  endfor

  if winwidth(0) < 86
    return shortfilename . modified
  else
    return name . modified
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 95 ? &fileformat : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 115 ? &fileencoding : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 85 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineGitBranch()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    if winwidth(0) > 54
      return branch !=# '' ? '  '.branch : ''
    else
      return branch !=# '' ? '' : ''
    endif
  endif
endfunction

let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
      \ 'component_function': {
      \   'filename'     : 'LightlineFilename',
      \   'fileencoding' : 'LightlineFileencoding',
      \   'fileformat'   : 'LightlineFileformat',
      \   'filetype'     : 'LightlineFiletype',
      \   'gitbranch'    : 'LightlineGitBranch',
      \ },
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ],
      \   'left':  [ [ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename' ] ]
      \ },
      \ 'mode_map': {
      \   'n': 'N',
      \   'i': 'I',
      \   'v': 'V',
      \   'V': 'VL',
      \ },
      \ }

let g:lightline.component_expand = {
      \ 'buffers': 'lightline#bufferline#buffers',
      \ }

let g:lightline.component_type = {
      \ 'buffers': 'tabsel',
      \ }

" === Lightline-bufferline ===
set showtabline=2
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#unnamed           = '*'
let g:lightline#bufferline#more_buffers      = '…'
let g:lightline#bufferline#unicode_symbols   = 0
let g:lightline#bufferline#shorten_path      = 1
let g:lightline#bufferline#smart_path        = 1
let g:lightline#bufferline#enable_devicons   = 1
let g:lightline#bufferline#icon_position     = 'left'
let g:lightline#bufferline#min_buffer_count  = 2
let g:lightline#bufferline#clickable         = 1
let g:lightline.component_raw               = {'buffers': 1}
let g:lightline.tabline = {'left': [['buffers']], 'right': [['']]}
let g:lightline#bufferline#show_number       = 1
let g:lightline#bufferline#number_map        = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}


" === NERDTree ===
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '^node_modules$[[dir]]', '\.sass-cache$']
let g:NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize = 50


" === netrw ===
if argv(0) ==# '.'
  let g:netrw_browse_split = 0
else
  let g:netrw_browse_split = 4
endif


" === vim-rooter ===
let g:rooter_targets = '/,*'
let g:rooter_patterns = ['.git', 'Makefile', '.editorconfig']


" === vim-signify ===
let g:signify_sign_delete = '-'


" === FZF ===
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--preview-window 'top,80%' --layout reverse --margin=0,1,0,1 --padding=0"
let $FZF_PREVIEW_COMMAND="COLORTERM=truecolor bat --theme='base16' --style=numbers --color=always --highlight-line 1:1 {}"


" ============================================================================ "
" ===                               UI OPTIONS                             === "
" ============================================================================ "

" Disable the bell sound entirely
set noerrorbells
set belloff=all

" Syntax highlighting (no Treesitter in Vim)
syntax on

set background=dark

" True color support (not available in macOS Terminal.app)
if !has('gui_running')
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Disable true color on macOS Terminal
if $TERM_PROGRAM ==# 'Apple_Terminal'
  set notermguicolors
  colorscheme desert
else
  colorscheme one
endif

" Darken the empty tabline background
highlight TabLineFill guibg=#282c34 ctermbg=235

" Italicize comments
highlight Comment cterm=italic gui=italic
highlight vimLineComment cterm=italic gui=italic

" No current line highlight
set nocursorline

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Splits open at bottom/right
set splitbelow
set splitright

" Mouse support
set mouse=a

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Reload file after disk change
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Performance
set lazyredraw
set ttyfast

" Buffer management
set hidden

" Timeouts
set ttimeout
set ttimeoutlen=70
set timeoutlen=800

" Backups and swap
setlocal nowritebackup
setlocal nobackup
set swapfile
set directory^=~/.vim/swap//
set backupcopy=auto
set backupdir^=~/.vim/backup
set updatetime=100

" Persistent undo
set undofile
set undodir^=~/.vim/undo//

" Display
set showcmd
set ruler
set number relativenumber
set signcolumn=yes
set wildmenu
set wildmode=longest:full,full

" Spell
set spelllang=en
set spellfile=$HOME/.vim/spell/en.utf-8.add

" Title
set title
set titlestring=%t

" git gutter colors
hi! SignifySignAdd    guibg=NONE guifg=#99c794
hi! SignifySignDelete guibg=NONE guifg=#ec5f67
hi! SignifySignChange guibg=NONE guifg=#c594c5

" Always show signcolumn
set signcolumn=yes

" Preview window highlight
function! Handle_Win_Enter()
  if &previewwindow
    setlocal winhighlight=Normal:MarkdownError
  endif
endfunction

augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Reload devicons after re-sourcing
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" vim-matchup
let g:matchup_matchparen_deferred = 1
let g:matchup_surround_enabled = 1

augroup matchup_matchparen_highlight
  autocmd!
  autocmd ColorScheme * hi MatchWord guibg=#3a3a3a gui=bold,underdotted
  autocmd ColorScheme * hi MatchParen guifg=black guibg=darkgray gui=bold,underdotted
augroup END


" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" Leader key
let mapleader="\<Space>"

" Save file
nnoremap <leader>w :w!<CR>

" Toggle column 80 highlight
nnoremap <silent> <leader>cc :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>

" Toggle line numbers and gutter
function! ToggleLineNumsAndGutter()
  let g:toggle_linenum = !get(g:, 'toggle_linenum', 1)

  augroup numbertoggle
    set nonumber
    set norelativenumber
    set signcolumn=no
    autocmd!
  augroup END

  if g:toggle_linenum
    set number relativenumber

    if has("patch-8.1.1564")
      set signcolumn=number
    else
      set signcolumn=yes
    endif

    augroup numbertoggle
      autocmd BufEnter,FocusGained,InsertLeave,WinEnter * set relativenumber
      autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * set norelativenumber
    augroup END
  endif
endfunction

nnoremap <leader>l :call ToggleLineNumsAndGutter()<CR>

" Find and replace word under cursor
function! ToggleZoom(zoom)
  if exists("t:restore_zoom") && (a:zoom == v:true || t:restore_zoom.win != winnr())
    exec t:restore_zoom.cmd
    unlet t:restore_zoom
  elseif a:zoom
    let t:restore_zoom = { 'win': winnr(), 'cmd': winrestcmd() }
    exec "normal \<C-W>\|\<C-W>_"
  endif
endfunction

augroup restorezoom
  au WinEnter * silent! :call ToggleZoom(v:false)
augroup END

nnoremap <leader>u :call ToggleZoom(v:true)<CR>:%s/<c-r><c-w>//g<left><left>

" Buffer management
nnoremap <leader>q :noautocmd Bwipeout<CR>
nnoremap <leader>Q :noautocmd Bwipeout!<CR>
nnoremap <leader>n :bn<CR>
nnoremap <leader>b :bp<CR>
nnoremap <leader>k :e #<CR>

" Toggle folds
nnoremap <leader>a za

" Toggle hidden characters
nnoremap <silent> <leader>H :set nolist!<CR>

" Insert empty line below/above
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

" Toggle zoom split
nnoremap <silent> <Leader>0 :call ToggleZoom(v:true)<CR>

" Ctrl-c as Escape in insert mode
inoremap <C-c> <Esc>

" Window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Insert mode readline-style shortcuts
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-e> <End>
imap <C-a> <Home>

" Command-line mode shortcuts
cnoremap <C-a> <Home>

" Resize splits with Ctrl-arrow
nmap <C-right> :vertical resize +1<CR>
nmap <C-left>  :vertical resize -1<CR>
nmap <C-up>    :resize +1<CR>
nmap <C-down>  :resize -1<CR>

" FZF shortcuts
nmap <leader>; :Buffers<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>: :History:<CR>

" Git
nnoremap <leader>h :SignifyHunkDiff<CR>

" Search and replace
map <leader>s :%s/

" Paste without yanking
vnoremap <leader>p "_dP

" Comment line (vim-commentary)
nmap <leader>/ gcc
vmap <leader>/ gc

" Tab pages
nnoremap t. :tabedit %<CR>
nnoremap tt :tabclose<CR>

" NERDTree
map <leader>r :tabedit<CR>:NERDTreeToggle<CR>
map <leader>e :NERDTreeFind<CR>

" Window splitting
nnoremap <leader>sp  :sp<CR><C-w>=
nnoremap <leader>vsp :vsp<CR><C-w>=

" Where am I (vim-matchup)
nnoremap <leader>? :<c-u>MatchupWhereAmI??<cr>
