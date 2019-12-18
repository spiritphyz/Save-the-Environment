" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Copy current buffer to system clipboard
" Instead of using pbcopy/pbpaste
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
set clipboard=unnamed

" Use spacebar as leader key instead of default '\'
let mapleader="\<Space>"

" Save file using leader
nnoremap <leader>w :w<cr>

" Quit using leader
nnoremap <leader>q :q<cr>

" Replace word under cursor using leader
nnoremap <leader>c :%s/\<<c-r><c-w>//g<left><left>

" Toggle show hidden characters with leader
nnoremap <silent> <leader>h :set nolist!<cr>

" Insert empty line without entering insert mode with leader
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<cr>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<cr>

" Switch to next, previous, and delete buffer
nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>
nnoremap <leader>d :bd<cr>

" Disable auto comments on new lines
set formatoptions-=cro

"Autoclose braces
"inoremap ( ()<Left>
"inoremap { {}<Left>
"inoremap [ []<Left>

" clear search highlighting by pressing Enter
nnoremap <CR> :noh<CR><CR>

filetype plugin indent on
syntax on
set encoding=utf-8
set tabstop=2
set expandtab
set autoindent
set shiftwidth=2
set scrolloff=3
set showcmd
set hidden
set wildmenu
set visualbell
set splitbelow
set ttyfast
set ruler
set backspace=indent,eol,start
set ignorecase
set smartcase
set gdefault
set showmatch
set wrap
set linebreak
set nolist
set shortmess+=c



" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" vim-plug auto
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

" Plugins go here like this:
" Plug '<link>'

call plug#end()


" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Enable true color support
set t_co=256

" Use cool color scheme
set background=dark
colorscheme one
call one#highlight('Visual', 'ffffff', 'e06c75', 'none')
call one#highlight('vimLineComment', '888888', '', 'none')

" Remove the current line highlight in unfocused windows
au VimEnter,WinEnter,BufWinEnter,FocusGained,CmdwinEnter * set cul
au WinLeave,FocusLost,CmdwinLeave * set nocul

" Remove trailing whitespace on save
autocmd! BufWritePre * :%s/\s\+$//e

" FZF settings
" Ctrl-p: fuzzy search open buffer names
" Ctrl-e: fuzzy search files in same folder at vim start
" Ctrl-i: Ripgrep inside files
"map <C-p> :Buffers<CR>
"map <C-e> :Files<CR>
"map <C-i> :Ag<CR>

" allow mouse reporting from iterm to allow click-to-position cursor in vim
set mouse=a

" turn on highlight all search patterns
set hlsearch

" search as characters are entered
set incsearch

" turn on line numbers
set number

" Use F2 key to enable paste mode before pasting in large amount of text
" to avoid auto-formatting. Press F2 again to exit paste mode.
set pastetoggle=<F2>

" Reload file after disk change, notify
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" faster redraw
" http://dougblack.io/words/a-good-vimrc.html
set lazyredraw
