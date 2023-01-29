" Use Unicode characters. Has to be at the top of the file.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif

" Avoid slow startup time on cold starts
" Linux:
"let g:python_host_prog  = '/usr/bin/python2'
"let g:python3_host_prog = '/usr/bin/python3'
" macOS with Homebrew:
let g:python_host_prog  = '/usr/local/opt/python/libexec/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Load plugins
source ~/.config/nvim/plugins.min-vscode.vim

" Load custom NodeJS version to address incompatibility
" between NVM (Node Version Manager) and CoC
"source ~/.config/nvim/nvm-coc.vim


" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Yank and paste with the system clipboard instead of using pbcopy/pbpaste
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
set clipboard=unnamed

" Disable auto comments on new lines
set formatoptions-=cro

" Toggle search highlighting by '\' instead of Enter,
" which interferes with command history window's 'execute'
nnoremap \ <Esc>:set hls!<CR>

" Search highlights are very distracting, esp. when you do 'c/<string>',
" so remove highlighting anytime you enter insert mode
" https://vi.stackexchange.com/a/17425
autocmd InsertEnter * :let @/=""

" Tab key behavior
" set expandtab         " use spaces instead of tabs
" set smarttab          " insert tab according to rules below
" set softtabstop=2     " # of spaces counted as tab during editing
" set shiftwidth=2      " # of spaces for indentation
" set tabstop=2
" set autoindent
" set smartindent

" Word wrapping, only insert line breaks when I press Enter
set wrap                           " wrap lines
set linebreak                      " visually wrap long lines on ^I!@*-+;:,./?

" for existing files, keep textwidths but don't let vim automatically reformat
" when typing on lines
set formatoptions+=1

" Indent based on filetype
" filetype on
" filetype plugin on
" filetype indent on
" Turn on OmniCompletion for tag completion in insert mode
" http://vim.wikia.com/wiki/Omni_completion
" To use omni completion, type <C-X><C-O> while open in Insert mode.
" If matching names are found, a pop-up menu opens which can be navigated
" using the <C-N> and <C-P> keys.
set omnifunc=syntaxcomplete#Complete

" make backspace delete over line breaks
" http://vim.wikia.com/wiki/Backspace_and_delete_problems
set backspace=indent,eol,start

" Allow cursor to move past last character,
" automatically pad spaces on new character insert
" https://keleshev.com/my-book-writing-setup/
"set virtualedit=all

" Allow folding based on TreeSitter syntax
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" When opening files, default to all folds open, not closed
" autocmd BufReadPost,FileReadPost * normal zR
" set nofoldenable


" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

" === netrw options ===
" Open files in prev window unless we're opening the current dir
if argv(0) ==# '.'
    let g:netrw_browse_split = 0
else
    let g:netrw_browse_split = 4
endif



" ============================================================================ "
" ===                                UI OPTIONS                            === "
" ============================================================================ "

" Enable true color support.
" Note: macOS Terminal app doesn't support true color,
" set notermguicolors later in this file.
if !has('gui_running')
  if (has("termguicolors"))
    set termguicolors
    colorscheme onedark
  endif
endif

" Use color syntax highlighting
" syntax on

" Use cool color scheme
set background=dark
lua <<EOF
  vim.g.onedark_style = 'dark'
  vim.g.onedark_italic_comment = true
  vim.g.onedark_diagnostics_undercurl = false
  vim.g.onedark_darker_diagnostics = true
  require('onedark').setup()
EOF

" Italicize inline comments, set after colorscheme and one#highlight
highlight Comment cterm=italic gui=italic
" Italicize whole line comments
highlight vimLineComment cterm=italic gui=italic

" Remove the current line highlight in unfocused windows
"au VimEnter,WinEnter,BufWinEnter,FocusGained,CmdwinEnter * set cul
"au WinLeave,FocusLost,CmdwinLeave * set nocul

" Turn off highlighting of current line
set nocursorline

" Remove trailing whitespace on save
"autocmd! BufWritePre * :%s/\s\+$//e

" Set new splits to appear at bottom
set splitbelow

" Allow mouse reporting from iterm to allow click-to-position cursor in vim
set mouse=a

" Turn on highlight all search patterns
set hlsearch

" Search as characters are entered
set incsearch

" Neovim: show effects of substitution incrementally.
" 'split' option will show all occurrences in preview window
"  but resets existing layout. For a workaround, run:
" ':Obsession'            save the current layout split to Session.vim file
" ':source Session.vim'   restore layout after substitution
"
" Or, open buffer in new tab page, run :%s//, then close tab
" :tabedit %              open current buffer in new tab
" :tabclose               close current tab
"
" Or, run the custom ToggleZoom() function before and after the substitution
" leader-0                zoom the current split
" :%s//                   run incremental substitution
" leader-0                restore splits to former sizes
set inccommand=split

" Use F2 key to enable paste mode before pasting in large amount of text
" to avoid auto-formatting. Press F2 again to exit paste mode.
set pastetoggle=<F4>

" Faster redraw
" http://dougblack.io/words/a-good-vimrc.html
set lazyredraw

" Hide buffers instead of closing them.
" Allows faster buffer switching, allows unsaved changes.
set hidden

set ttyfast                     " More characters will be sent to screen for redrawing
set ttimeout                    " Turn on custom wait time for keypress
set ttimeoutlen=70              " Key codes wait period (like arrow keys)
" Mapping wait period before abort and carry out behavior of keys typed so far
" https://vi.stackexchange.com/a/24938
set timeoutlen=800

" Protect changes between writes. Default values for updatecount (200 keystrokes)
" and updatetime (4 seconds) are fine.
" Disabling all backup options due to tsserver incompatibilities.
" See: https://github.com/neoclide/coc.nvim/issues/649
"set swapfile
set directory^=~/.nvim/swap//
"set writebackup                 " Protect against crash-during-write
"set nobackup                    " but do not persist backup after successful write.
"set backupcopy=auto             " Use rename-and-write-new method whenever safe.
"set backupdir^=~/.nvim/backup   " Consolidate the write backups.
set nowritebackup
set nobackup
set updatetime=100               " make CoC plugins much more responsive

" Persist the undo tree for each file.
set undofile
set undodir^=~/.nvim/undo//

"set scrolloff=2                 " Always show 2 lines above/below cursor
set showcmd                     " Show incomplete commands
set ruler                       " Show cursor position
set ignorecase                  " Ignore case while searching except
set smartcase                   " when already has one capital letter

" Show hybrid line numbers (relative except for current line)
set number relativenumber

" Better menu completion in command mode
set wildmenu
set wildmode=longest:full,full

" Don't give completion messages like 'match 1 of 2' or 'The only match'
"set shortmess+=c

" Set floating window to be slightly transparent
set winblend=10

" Make background transparent for many things
hi! Normal ctermbg=NONE guibg=NONE " removes 'hazy' bg color from termguicolors
hi! NonText ctermbg=NONE guibg=NONE
hi! LineNr ctermfg=NONE guibg=NONE
hi! SignColumn ctermfg=NONE guibg=NONE
hi! StatusLine guifg=#16252b guibg=#6699CC
hi! StatusLineNC guifg=#16252b guibg=#16252b

" Disable True Color support on macOS Terminal
" Needs to be set after custom transparent color changes
if $TERM_PROGRAM ==# 'Apple_Terminal'
  set notermguicolors
  colorscheme desert
endif

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

" Don't automatically resize window splits when creating or closing windows.
" Helps NERDTreeToggle not clobber current widths of horizontal splits.
" https://stackoverflow.com/a/61732698
set noequalalways


" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" === Leader key shorcuts === "
" Use spacebar as leader key instead of default '\'
" '\' is remapped to 'clear search highlighting'
let mapleader="\<Space>"

" Save file [can't put this comment at end of line or else cursor jumps]
" https://vi.stackexchange.com/a/6922
nnoremap <leader>w :w!<CR>
" Toggle highlight at column 80
nnoremap <silent> <leader>cc :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>
" Toggle line numbers and gutter (signcolumn) for easier Tmux copy
nnoremap <leader>l :call ToggleLineNumsAndGutter()<CR>
" Toggle display of indent guides
nnoremap <leader>i :IndentBlanklineToggle<CR>
" Find and replace word under cursor (mnemonic: c_u_rsor)
" ToggleZoom first to avoid resetting split layout
nnoremap <leader>u :call ToggleZoom(v:true)<CR>:%s/<c-r><c-w>//g<left><left>
" Close buffer w/o closing split
nnoremap <leader>q :Bwipeout<CR>
" Show hunk diff in gutter
nnoremap <leader>h :SignifyHunkDiff<CR>
" Switch to next buffer
nnoremap <leader>n :bn<CR>
" Switch to prev buffer
nnoremap <leader>b :bp<CR>
" Delete buffer (capital D)
nnoremap <leader>D :bd<CR>
" Toggle hidden characters (capital H)
nnoremap <silent> <leader>H :set nolist!<CR>
" Insert empty line before and after
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<Left><Left><CR>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<Left><Left><CR>


" === Denite shortcuts === "
"   <leader>; - Fuzzy search open buffers (like FZF or Ctrl-P)
"   <leader>f - Browse list of files in current directory
"   <leader>t - Search for files in project directory
"   <leader>g - Search curr directory for given term, close window if no results
"   <leader>j - Search curr directory for occurrences of word under cursor
"   <leader>: - Fuzzy search command history (non-fuzzy default is q:)
"           i - After triggers above, press 'i' to enter fuzzy filter mode
nmap <leader>; :Denite buffer<CR>
nmap <leader>f :Denite file/rec<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>i
nnoremap <leader>g <C-u>:Denite grep:. -no-empty<CR>
nnoremap <leader>j :DeniteCursorWord grep:.<CR>
nnoremap <leader>: :Denite command_history<CR>

" Define Denite mappings while in 'filter' mode
"   <C-o>          - Switch to normal mode inside of search results
"   <Esc> or <C-c> - Exit denite window in any mode
"   <CR>           - Open currently selected file in any mode
"   <C-t>          - Open currently selected file in a new tab
"   <C-v>          - Open currently selected file a vertical split
"   <C-h>          - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <C-c>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in Denite window
"   o or <CR>             - Opens currently selected file
"   q or <Esc> or <C-c>   - Quit Denite window
"   d                     - Delete currenly selected file
"   p                     - Preview currently selected file
"   <C-o> or i            - Switch to insert mode for filtering buffer
"   <C-t>                 - Open currently selected file in a new tab
"   <C-v>                 - Open currently selected file a vertical split
"   <C-h>                 - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> o
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction


" Ctrl-hjkl for quick window switching (Vim split panes)
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Insert mode shortcuts like emacs/readline
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-e> <End>
imap <C-a> <Home>

" Ctrl-arrow keys to resize Vim split panes
nmap <C-right> :vertical resize +1<CR>
nmap <C-left> :vertical resize -1<CR>
nmap <C-up> :resize +1<CR>
nmap <C-down> :resize -1<CR>

" leader-0 to toggle zoom split
" Mnemonic: 0 looks like 'o' for Vim's ctrl-w o ("only this split")
" leader-o and leader-O are already mapped to 'add blank line above, below'
" Awesome toggle function written by stackoverflow user 'ata':
" https://stackoverflow.com/a/60639802
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
nnoremap <silent> <Leader>0 :call ToggleZoom(v:true)<CR>

" Ctrl-c remapped to Escape to avoid leftover artifacts with CoC menus.
" https://github.com/neoclide/coc.nvim/issues/1469
inoremap <C-c> <Esc>

" Switch to last open buffer with <leader>k
" Default of ctrl-^ (or ctrl-6) conflicts with Mosh interrupt
" This method doesn't work with unnamed buffers (ctrl-^ does)
nmap <leader>k :e #<CR>

" Paste Over Do Not Yank:
" Delete current visual selection and dump in black hole buffer before pasting
" Used when you want to paste over something without it getting copied to
" Vim's default buffer
" vnoremap <leader>p "_dhp

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" === key mappings for tab pages ===
nnoremap t. :tabedit %<CR>
nnoremap tc :tabclose<CR>


" === NERDTree key mappings ===
"  <leader>r - Toggle NERDTree panel (<leader>n is next buffer)
"  <leader>e - Show current file in containing folder
" map <leader>r :NERDTreeToggle<CR>
" map <leader>e :NERDTreeFind<CR>


" === nvim-tree key mappings ===
" disabling because it keeps resizing window splits when open
" nnoremap <leader>r :NvimTreeToggle<CR>
" nnoremap <leader>e :NvimTreeFindFile<CR>
" " NvimTreeRefresh, NvimTreeOpen, NvimTreeClose, NvimTreeFocus and NvimTreeResize are also available if you need them
" let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
" let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
" let g:nvim_tree_gitignore = 1 "0 by default
" let g:nvim_tree_indent_markers = 0 "0 by default, this option shows indent markers when folders are open
" let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
" let g:nvim_tree_show_icons = {
"     \ 'git': 0,
"     \ 'folders': 1,
"     \ 'files': 1,
"     \ 'folder_arrows': 1,
"     \ }
" let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
" lua << EOF
" require'nvim-tree'.setup({
"   view = {
"     width = 30,
"     auto_resize = false
"   }
" })
" EOF

" === Search shorcuts ===
"  <leader>s - For all lines in file, search and replace
" Call ToggleZoom first to avoid resetting split layout
map <leader>s :call ToggleZoom(v:true)<CR>:%s/

