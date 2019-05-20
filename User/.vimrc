" Copy current buffer to system clipboard
" Instead of using pbcopy/pbpaste
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
set clipboard=unnamed

" highline current line
set cursorline

" faster redraw
" http://dougblack.io/words/a-good-vimrc.html
set lazyredraw

" abbreviations
" http://vim.wikia.com/wiki/Using_abbreviations
ab ccll console.log(
ab cclll console.log('');
ab ffll for (var i = 0; i < x.length; i += 1) {}

" enable HTML tag completions
" use ctrl-x, ctrl-o to complete tag
" enable auto-complete when HTML file is opened
" https://docs.oseems.com/general/application/vim/auto-complete-html
":set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" below from:
" http://stackoverflow.com/questions/235839/indent-multiple-lines-quickly-in-vi
set expandtab			"Use softtabstop spaces instead of tab characters
set shiftwidth=2	"Indent by 2 spaces when using >>, <<, == etc.
set softtabstop=2	"Indent by 2 spaces when pressing <TAB>

set autoindent		"Keep indentation from previous line
set smartindent		"Automatically inserts indentation in some cases
set cindent				"Like smartindent, but stricter and more customizable

" make backspace delete over line breaks
" http://vim.wikia.com/wiki/Backspace_and_delete_problems
set backspace=indent,eol,start

" set tabs to be 2 spaces each
set ts=2

" Use color syntax highlighting
syntax on

" enable JSX syntax highlighting
" http://stackoverflow.com/questions/34578154/how-to-add-react-jsx-as-javascript-file-type-in-vim-and-enable-eslinting-auto-c
let g:jsx_ext_required = 0

" default syntax highlighting is too dark, fix it
set background=dark

set ruler

" ignore case while searching
set ic

" for word wrapping but only insert line breaks when i press Enter
set wrap
set linebreak
set nolist " list disables linebreak
set textwidth=0
set wrapmargin=0

" for existing files, keep textwidths but don't let vim automatically reformat when typing on lines
set formatoptions+=1

" enable 256 color palette
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

" split a pair of braces to type in the middle with Ctrl-J
imap <C-j> <CR><Esc>O

" map Ctrl-J to insert blank line after, Shift-J before
" http://superuser.com/questions/607163/inserting-a-blank-line-in-vim
map <C-k> o<Esc>
map <S-k> O<Esc>

" stop auto coment insertion due to file type detection
" http://vim.wikia.com/wiki/Disable_automatic_comment_insertion
" (this doesn't work, don't know why)
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" disable all auto comments that cause first-line comment to spoil pasted text
" http://vi.stackexchange.com/questions/1983/how-can-i-get-vim-to-stop-putting-comments-in-front-of-new-lines
"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
"au FileType js setlocal comments-=:// comments+=f://
"au FileType js setlocal fo-=c fo-=r fo-=o
au FileType * setlocal fo-=c fo-=r fo-=o

" watch for changes in .vimrc and auto reload
" http://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END


" ------------------------------------------------------------------------------
" Vim-Plug plugin manager, fast parallel updates
" https://github.com/junegunn/vim-plug
"
" List plugins with ':PlugStatus'
" Install updates with ':PlugInstall'
" ------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
"Plug 'junegunn/seoul256.vim'
"Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/syntastic'

"these are good for re-enabling
Plug 'Valloric/YouCompleteMe'
Plug 'marijnh/tern_for_vim'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'
Plug 'joshdick/onedark.vim'

" Group dependencies, vim-snippets depends on ultisnips
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" to activate indent guide, press Leader key \ and then ig, but do it fast
"Plug 'nathanaelkane/vim-indent-guides', { 'for': 'javascript' }
Plug 'Shutnik/jshint2.vim', { 'for': 'javascript' }

" Using git URL
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Plugin options
"'Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

call plug#end()

" ----------------------------------------------------------------------------
" syntastic linter settings
" ----------------------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
" working with partials to avoid linting errors
" https://github.com/scrooloose/syntastic/issues/240
let g:syntastic_html_tidy_ignore_errors = [ '<template> is not recognized!' ]
" ignore Angular proprietary attributes
" http://stackoverflow.com/questions/18270355/how-can-i-ignore-angular-directive-lint-errors-with-vim-and-syntastic
let g:syntastic_html_tidy_ignore_errors=[
    \'proprietary attribute "ng-',
    \'proprietary attribute "data',
    \'proprietary attribute "pdk-'
    \]
" better :sign interface symbols
" http://blog.thomasupton.com/2012/05/syntastic/
let g:syntastic_error_symbol = '🔸'
let g:syntastic_warning_symbol = '🔹'


" -----------------------------------------------------------------------------
" more post-changes after plugs are loaded
" -----------------------------------------------------------------------------
" turn on OmniCompletion for YouCompleteMe + tern
" http://vim.wikia.com/wiki/Omni_completion
" To use omni completion, type <C-X><C-O> while open in Insert mode. 
" If matching names are found, a pop-up menu opens which can be navigated 
" using the <C-N> and <C-P> keys.
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" only do linting on file save 
" https://github.com/Shutnik/jshint2.vim
let jshint2_save = 1

