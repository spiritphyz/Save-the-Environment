" Use Unicode characters. Has to be at the top of the file.
" The order of these commands is important.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Yank and paste with the system clipboard
" Instead of using pbcopy/pbpaste
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
set clipboard=unnamed

" Disable auto comments on new lines
set formatoptions-=cro

"Autoclose braces
"inoremap ( ()<Left>
"inoremap { {}<Left>
"inoremap [ []<Left>

" clear search highlighting by pressing Enter
nnoremap <CR> :noh<CR><CR>

" Tab key behavior
set expandtab " use spaces instead of tabs
set smarttab
set softtabstop=2 " # of spaces that counts as a tab during editing ops
set shiftwidth=2
set tabstop=2
set autoindent " apply current indentation to next line
set smartindent " reacts to syntax of your code

" Word wrapping, only insert line breaks when I press Enter
set wrap " wrap lines
set linebreak " visually wrap long lines on ^I!@*-+;:,./? character

" for existing files, keep textwidths but don't let vim automatically reformat when typing on lines
set formatoptions+=1

" Turn on OmniCompletion for tag completion in insert mode
" http://vim.wikia.com/wiki/Omni_completion
" To use omni completion, type <C-X><C-O> while open in Insert mode.
" If matching names are found, a pop-up menu opens which can be navigated
" using the <C-N> and <C-P> keys.
" filetype plugin on
filetype plugin indent on " auto-indent based on filetype
set omnifunc=syntaxcomplete#Complete

" make backspace delete over line breaks
" http://vim.wikia.com/wiki/Backspace_and_delete_problems
set backspace=indent,eol,start

" TODO: check what these settings do
set gdefault
set showmatch
set nolist
set shortmess+=c


" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

" === vim-plug options ===
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

" Plugins go here
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'         " allows table formatting in Markdown
Plug 'elzr/vim-json'             " for front matter highlighting
Plug 'plasticboy/vim-markdown'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'crusoexia/vim-javascript-lib'
Plug 'tpope/vim-surround'
Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons' " should be loaded as last plugin

call plug#end()


" === vim-markdown options ===
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


" === Lightline options ===
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


" === Lightline-bufferline options ===
set showtabline=2
let g:lightline#bufferline#filename_modifier = ':t' " only filename, no path
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#unicode_symbols = 0
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline.tabline = {'left': [['buffers']], 'right': [['close']]}


" === Prettier options ===
nmap <Leader>pr <Plug>(Prettier)
let g:prettier#exec_cmd_async = 1     " make :Prettier be async
let g:prettier#config#semi = 'false'  " don't use semicolons
let g:prettier#config#single_quote = 'true'     " prefer single quotes
let g:prettier#config#bracket_spacing = 'false' " no space between brackets
let g:prettier#config#jsx_bracket_same_line = 'true' " put > on single line
let g:prettier#config#arrow_parens = 'always'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#parser = 'flow'
let g:prettier#config#prose_wrap = 'preserve'
let g:prettier#config#html_whitespace_sensitivity = 'css'


" ============================================================================ "
" ===                                UI OPTIONS                            === "
" ============================================================================ "

" Enable true color support
"set termguicolors " causes undesirable light gray background color
if !has('gui_running')
  set t_Co=256
endif

" Use color syntax highlighting
syntax on

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

" Set new splits to appear at bottom
set splitbelow

" Allow mouse reporting from iterm to allow click-to-position cursor in vim
set mouse=a

" Turn on highlight all search patterns
set hlsearch

" Search as characters are entered
set incsearch

" Use F2 key to enable paste mode before pasting in large amount of text
" to avoid auto-formatting. Press F2 again to exit paste mode.
set pastetoggle=<F2>

" Reload file after disk change, notify
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Watch for changes in .vimrc and auto reload
" http://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim
augroup myvimrc
  au!
  au BufWritePost init.vim,plugins.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" Reload dev-icons after init source
"if exists('g:loaded_webdevicons')
"  call webdevicons#refresh()
"endif

" Faster redraw
" http://dougblack.io/words/a-good-vimrc.html
set lazyredraw

" Hide buffers instead of closing them.
" Allows faster buffer switching, allows unsaved changes
set hidden

" More characters will be sent to screen for redrawing
set ttyfast

" Turn on custom wait time for keypress
set ttimeout

" Make keypress wait period shorter
set ttimeoutlen=70

" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime (4 seconds) are fine
set swapfile
set directory^=~/.nvim/swap//

" Protect against crash-during-write
set writebackup
" but do not persist backup after successful write.
set nobackup
" Use rename-and-write-new method whenever safe.
set backupcopy=auto

" Consolidate the writebackups.
set backupdir^=~/.nvim/backup

" Persist the undo tree for each file.
set undofile
set undodir^=~/.nvim/undo//

" Better menu completion in command mode
set wildmenu
set wildmode=longest:full,full

" Always show 2 lines above/below the cursor
set scrolloff=2

" Show incomplete commands
set showcmd
"
" Show cursor position
set ruler
set nonumber " but turn off line numbers

" Ignore case while searching
set ignorecase
set smartcase " unless already has one capital letter


" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

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

" === FZF key mappings ===
" Ctrl-p: fuzzy search open buffer names
" Ctrl-e: fuzzy search files in same folder at vim start
" Ctrl-i: Ripgrep inside files
"map <C-p> :Buffers<CR>
"map <C-e> :Files<CR>
"map <C-i> :Ag<CR>

" === NERDTree key mappings ===
"map <C-n> :NERDTreeToggle<CR>

" Split a pair of braces to type in the middle with Ctrl-J
imap <C-j> <CR><Esc>O

" Map Ctrl-J to insert blank line after, Shift-J before
" http://superuser.com/questions/607163/inserting-a-blank-line-in-vim
map <C-k> o<Esc>
map <S-k> O<Esc>

" === Abbreviations ===
" http://vim.wikia.com/wiki/Using_abbreviations
ab cll console.log(
ab fll for (var i = 0; i < x.length; i += 1) {}
