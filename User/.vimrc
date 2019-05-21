" Use Unicode characters. Has to be at the top of the file.
" The order of these commands is important.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif

" Copy current buffer to system clipboard
" Instead of using pbcopy/pbpaste
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
set clipboard=unnamed

" Turn off spell-checking, causes underlining in Markdown files
set nospell

" Disable Polyglot Markdown, interferes with vim-markdown
let g:polyglot_disabled = ['markdown']

" highline current line
" 256 color palette needed to avoid ugly underlining
set cursorline

" faster redraw
" http://dougblack.io/words/a-good-vimrc.html
set lazyredraw

" Tab behavior
" http://stackoverflow.com/questions/235839/indent-multiple-lines-quickly-in-vi
set expandtab			" Use softtabstop spaces instead of tab characters
set shiftwidth=2	" Indent by 2 spaces when using >>, <<, == etc.
set softtabstop=2	" Indent by 2 spaces when pressing <TAB>
set ts=2          " Set tabs to be 2 spaces each

set autoindent		"Keep indentation from previous line
set smartindent		"Automatically inserts indentation in some cases
set cindent				"Like smartindent, but stricter and more customizable

" Word wrapping, but only insert line breaks when I press Enter
set wrap
set linebreak
set nolist " list disables linebreak
set textwidth=0
set wrapmargin=0

" for existing files, keep textwidths but don't let vim automatically reformat when typing on lines
set formatoptions+=1

" Turn on OmniCompletion for tag completion in insert mode
" http://vim.wikia.com/wiki/Omni_completion
" To use omni completion, type <C-X><C-O> while open in Insert mode. 
" If matching names are found, a pop-up menu opens which can be navigated 
" using the <C-N> and <C-P> keys.
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" make backspace delete over line breaks
" http://vim.wikia.com/wiki/Backspace_and_delete_problems
set backspace=indent,eol,start

" Use color syntax highlighting
syntax on

" enable JSX syntax highlighting
" http://stackoverflow.com/questions/34578154/how-to-add-react-jsx-as-javascript-file-type-in-vim-and-enable-eslinting-auto-c
let g:jsx_ext_required = 0

" default syntax highlighting is too dark, fix it
set background=dark

" show cursor position
set ruler

" ignore case while searching
set ic

" enable 256 color palette for vim-distinguished theme
set t_Co=256

" use cool color scheme
colorscheme onedark

" clear search highlighting by pressing Enter
nnoremap <CR> :noh<CR><CR>

" allow mouse reporting from iterm to allow click-to-position cursor in vim
set mouse=a

" turn on highlight all search patterns
set hlsearch

" search as characters are entered
set incsearch

" turn on line numbers
set number

" FZF settings
map <C-p> :Files<CR>

" Map Ctrl-n for NERDTree
map <C-n> :NERDTreeToggle<CR>

" enable lightline
set laststatus=2
set noshowmode " turn off extra -- INSERT --

" Change colors to be darker for status bar and tab bar
let g:lightline = {
      \ 'colorscheme': 'darcula',
      \ }

let g:lightline.component_expand = {
      \  'buffers': 'lightline#bufferline#buffers',
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'buffers': 'tabsel', 
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

" Lightline-bufferline settings
set showtabline=2
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#unicode_symbols = 0
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}

" Split a pair of braces to type in the middle with Ctrl-J
imap <C-j> <CR><Esc>O

" Map Ctrl-J to insert blank line after, Shift-J before
" http://superuser.com/questions/607163/inserting-a-blank-line-in-vim
map <C-k> o<Esc>
map <S-k> O<Esc>

" Stop auto coment insertion due to file type detection
" http://vim.wikia.com/wiki/Disable_automatic_comment_insertion
" (this doesn't work, don't know why)
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" disable all auto comments that cause first-line comment to spoil pasted text
" http://vi.stackexchange.com/questions/1983/how-can-i-get-vim-to-stop-putting-comments-in-front-of-new-lines
"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
"au FileType js setlocal comments-=:// comments+=f://
"au FileType js setlocal fo-=c fo-=r fo-=o
au FileType * setlocal fo-=c fo-=r fo-=o

" Watch for changes in .vimrc and auto reload
" http://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" Abbreviations
" http://vim.wikia.com/wiki/Using_abbreviations
ab cll console.log(
ab fll for (var i = 0; i < x.length; i += 1) {}


" ------------------------------------------------------------------------------
" Vim-Plug plugin manager, fast parallel updates
" https://github.com/junegunn/vim-plug
"
" List plugins with ':PlugStatus'
" Install updates with ':PlugInstall'
" ------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'gabrielelana/vim-markdown'
Plug 'mattn/emmet-vim'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'
Plug 'tpope/vim-surround'
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons' " should be loaded as last plugin

call plug#end()

