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

" Use spacebar as leader key instead of default '\'
let mapleader="\<Space>"

"Shortcut for saving file using leader
nnoremap <leader>w :w<cr>

"Shortcut for quitting using leader
nnoremap <leader>q :q<cr>

"Shortcut to replace word under cursor using leader
nnoremap <leader>c :%s/\<<c-r><c-w>//g<left><left>

" Toggle show hidden characters
nnoremap <silent> <leader>h :set nolist!<cr>

" Insert empty line without entering insert mode
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

"Autoclose braces
"This interferes with pasting in JSON files with quotes
"inoremap ( ()<Left>
"inoremap { {}<Left>
"inoremap [ []<Left>

" highline current line
" 256 color palette needed to avoid ugly underlining
set cursorline

" faster redraw
" http://dougblack.io/words/a-good-vimrc.html
set lazyredraw

" More characters will be sent to screen for redrawing
set ttyfast

" Turn on cusotm wait time for keypress
set ttimeout

" Make keypress wait period shorter
set ttimeoutlen=70

" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
set swapfile
 set directory^=~/.vim/swap//

" protect against crash-during-write
 set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
" patch required to honor double slash at end
if has("patch-8.1.0251")
  " consolidate the writebackups -- not a big
  " deal either way, since they usually get deleted
  set backupdir^=~/.vim/backup//
end

" persist the undo tree for each file
  set undofile
  set undodir^=~/.vim/undo//

" Better menu completion in command mode
set wildmenu
set wildmode=longest:full,full

" Always show 2 lines above/below the cursor
set scrolloff=2

" Show incomplete commands
set showcmd

" Tab key behavior
set expandtab " use spaces instead of tabs
set smarttab
set shiftwidth=2
set tabstop=2
set ai " auto indent
set si " smart indent

" for word wrapping but only insert line breaks when I press Enter
set wrap " wrap lines

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

" default syntax highlighting is too dark, fix it
set background=dark

" show cursor position
set ruler

" ignore case while searching
set ignorecase

" Don't ignore case unless already has one capital letter
set smartcase

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

" Disable auto comments on new lines
set formatoptions-=cro

" Remove the current line highlight in unfocused windows
au VimEnter,WinEnter,BufWinEnter,FocusGained,CmdwinEnter * set cul
au WinLeave,FocusLost,CmdwinLeave * set nocul

" Remove trailing whitespace on save
autocmd! BufWritePre * :%s/\s\+$//e

" FZF settings
" Ctrl-p: fuzzy search open buffer names
" Ctrl-e: fuzzy search files in same folder at vim start
" Ctrl-g: Ripgrep inside files
map <C-p> :Buffers<CR>
map <C-e> :Files<CR>
map <C-g> :Ag<CR>

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
let g:lightline#bufferline#filename_modifier = ':t' " only filename, no path
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#unicode_symbols = 0
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}

" vim-markdown settings
let g:vim_markdown_folding_disabled = 1
let g:markdown_enable_spell_checking = 0
let g:polyglot_disabled = ['md', 'markdown'] " interferes with vim-markdown
let g:vim_markdown_fenced_languages = ['bash=sh', 'c', 'css', 'go', 'html', 'javascript', 'python', 'ruby', 'scss']
let g:vim_markdown_frontmatter = 1           " highlight YAML front matter
let g:vim_markdown_json_frontmatter = 1      " highlight JSON front matter
let g:vim_markdown_conceal = 0
let g:vim_markdown_new_list_item_indent = 2
autocmd FileType markdown highlight htmlH1 cterm=none ctermfg=70
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Split a pair of braces to type in the middle with Ctrl-J
imap <C-j> <CR><Esc>O

" Map Ctrl-J to insert blank line after, Shift-J before
" http://superuser.com/questions/607163/inserting-a-blank-line-in-vim
map <C-k> o<Esc>
map <S-k> O<Esc>

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
Plug 'godlygeek/tabular'         " allows table formatting in Markdown
Plug 'elzr/vim-json'             " for front matter highlighting
Plug 'plasticboy/vim-markdown'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'
Plug 'tpope/vim-surround'
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons' " should be loaded as last plugin

call plug#end()

