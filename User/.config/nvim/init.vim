" Use Unicode characters. Has to be at the top of the file.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif

" Load plugins
source ~/.config/nvim/plugins.vim


" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Yank and paste with the system clipboard instead of using pbcopy/pbpaste
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


" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

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
"nmap <Leader>pr <Plug>(Prettier)
"let g:prettier#exec_cmd_async = 1     " make :Prettier be async
"let g:prettier#config#single_quote = 'true'     " prefer single quotes
"let g:prettier#config#bracket_spacing = 'false' " no space between brackets
"let g:prettier#config#jsx_bracket_same_line = 'true' " put > on single line
"let g:prettier#config#arrow_parens = 'always'
"let g:prettier#config#trailing_comma = 'all'
"let g:prettier#config#parser = 'flow'
"let g:prettier#config#prose_wrap = 'preserve'
"let g:prettier#config#html_whitespace_sensitivity = 'css'
" Use :Prettier command to format current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:prettier#config#semi = 'false'  " don't use semicolons


" === NERDTree options ===
" Show hidden files/directories
let g:NERDTreeShowHidden = 1

" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']


" === coc options ===
let g:coc_global_extensions = ["coc-css",
            \ "coc-eslint",
            \ "coc-html",
            \ "coc-json",
            \ "coc-prettier",
            \ "coc-python",
            \ "coc-tslint",
            \ "coc-tsserver"]

" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif


" ============================================================================ "
" ===                                UI OPTIONS                            === "
" ============================================================================ "

" Enable true color support
if !has('gui_running')
  if (has("termguicolors"))
    set termguicolors
  endif
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
"au VimEnter,WinEnter,BufWinEnter,FocusGained,CmdwinEnter * set cul
"au WinLeave,FocusLost,CmdwinLeave * set nocul

" Turn off highlighting of current line
set nocursorline

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
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

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

" Consolidate the write backups.
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

" Don't give completion messages like 'match 1 of 2' or 'The only match'
set shortmess+=c

" Add custom highlights in method that is executed every time a colorscheme is sourced
" See https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f for details
function! MyHighlights() abort
  " Hightlight trailing whitespace
  highlight Trail ctermbg=red guibg=red
  call matchadd('Trail', '\s\+$', 100)
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END

" Set floating window to be slightly transparent
set winblend=10

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type
"hi! CocFloating ctermbg=8 ctermfg=15

" Make background transparent for many things
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi! LineNr ctermfg=NONE guibg=NONE
hi! SignColumn ctermfg=NONE guibg=NONE
hi! StatusLine guifg=#16252b guibg=#6699CC
hi! StatusLineNC guifg=#16252b guibg=#16252b

" Make background color transparent for git changes
hi! SignifySignAdd guibg=NONE
hi! SignifySignDelete guibg=NONE
hi! SignifySignChange guibg=NONE

" Highlight git change signs
hi! SignifySignAdd guifg=#99c794
hi! SignifySignDelete guifg=#ec5f67
hi! SignifySignChange guifg=#c594c5

" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of preview window when open
function! Handle_Win_Enter()
  if &previewwindow
    setlocal winhighlight=Normal:MarkdownError
  endif
endfunction


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
nnoremap <leader>N :bp<cr>
nnoremap <leader>d :bd<cr>

" === FZF key mappings ===
" Ctrl-p: fuzzy search open buffer names
" Ctrl-e: fuzzy search files in same folder at vim start
" Ctrl-i: Ripgrep inside files
"map <C-p> :Buffers<CR>
"map <C-e> :Files<CR>
"map <C-i> :Ag<CR>

" === NERDTree key mappings ===
"  <leader>n - Toggle NERDTree on/off
"  <leader>f - Opens current file location in NERDTree
map <leader>t :NERDTreeToggle<CR>
map <leader>f :NERDTreeFind<CR>

" === coc-prettier key mappings ===
" Create range first, then <leader>p to Prettier format
map <leader>p <Plug>(coc-format-selected)

" === coc.nvim ===
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)

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
