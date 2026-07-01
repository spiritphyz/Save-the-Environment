" ============================================================================ "
" ===                      USE NEOVIM FOR GIT COMMIT                       === "
" ============================================================================ "
" Set nvim (with minimal plugins) as editor:
" git config --global core.editor "nvim -u ~/.config/nvim/init-git-editor.vim"
"
" Verify Neovim as default editor for Git commit messages:
" git config --global --get core.editor
" nvim -u ~/.config/nvim/init-git-editor.vim


" Use Unicode characters. Has to be at the top of the file.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif

" Load minimal set of plugins
source ~/.config/nvim/plugins.min-git.vim


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
set expandtab         " use spaces instead of tabs
set smarttab          " insert tab according to rules below
set softtabstop=2     " # of spaces counted as tab during editing
set shiftwidth=2      " # of spaces for indentation
set tabstop=2
set autoindent
set smartindent

" Word wrapping, only insert line breaks when I press Enter
set wrap                           " wrap lines
set linebreak                      " visually wrap long lines on ^I!@*-+;:,./?

" for existing files, keep textwidths but don't let vim automatically reformat
" when typing on lines
set formatoptions+=1

" Indent based on filetype
filetype on
filetype plugin on
filetype indent on
" Turn on OmniCompletion for tag completion in insert mode
" http://vim.wikia.com/wiki/Omni_completion
" To use omni completion, type <C-X><C-O> while open in Insert mode.
" If matching names are found, a pop-up menu opens which can be navigated
" using the <C-N> and <C-P> keys.
set omnifunc=syntaxcomplete#Complete

" make backspace delete over line breaks
" http://vim.wikia.com/wiki/Backspace_and_delete_problems
set backspace=indent,eol,start


" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

" === Lightline options ===
set laststatus=2
"set noshowmode " turn off extra -- INSERT --

" Define functions
function! s:lightline_coc_diagnostic(kind, sign) abort
  let info = get(b:, 'coc_diagnostic_info', 0)
  if empty(info) || get(info, a:kind, 0) == 0
    return ''
  endif
  try
    let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
  catch
    let s = ''
  endtry
  return printf('%s %d', s, info[a:kind])
endfunction

function! LightlineCocErrors() abort
  return s:lightline_coc_diagnostic('error', 'error')
endfunction

function! LightlineCocWarnings() abort
  return s:lightline_coc_diagnostic('warning', 'warning')
endfunction

function! LightlineCocInfos() abort
  return s:lightline_coc_diagnostic('information', 'info')
endfunction

function! LightlineFilename()
  let shortfilename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  "let filename = expand('%:t') !=# '' ? expand('%:p:h:t') . '/' . expand('%:t') : '[No Name]'
  " show relative path
  " let filename = expand('%:t') !=# '' ? expand('%') : '[No Name]'
  let modified = &modified ? ' 🍄' : ''

  " show relative path trimmed to 4 characters per folder
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
    " return filename . modified
    return name . modified
  endif
endfunction

" Ex: unix
function! LightlineFileformat()
  return winwidth(0) > 95 ? &fileformat : ''
endfunction

" Ex: utf-8
function! LightlineFileencoding()
  return winwidth(0) > 115 ? &fileencoding : ''
endfunction

" Ex: reactjavascript
function! LightlineFiletype()
  return winwidth(0) > 85 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineGitBranch()
  if exists ('*FugitiveHead')
    let branch = FugitiveHead()
    if winwidth(0) > 54
      return branch !=# '' ? ' '.branch : ''
    else
      return branch !=# '' ? '' : ''
    endif
  endif
endfunction

function! LightlineCocHints() abort
  return s:lightline_coc_diagnostic('hints', 'hint')
endfunction

autocmd User CocDiagnosticChange call lightline#update()

" Configure statusline
" Old colorscheme was ayu_mirage
" \   'zoomstate'         : 'LightlineVimZoomStatus'
" \             [ 'zoomstate', 'gitbranch', 'readonly', 'filename', 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ]
let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \ 'component': {
      \   'fileformat': '%3l:%-2v%<',
      \   'filetype': '%3l:%-2v%<',
      \ },
      \ 'component_function': {
      \   'filename'          : 'LightlineFilename',
      \   'fileencoding'      : 'LightlineFileencoding',
      \   'fileformat'        : 'LightlineFileformat',
      \   'filetype'          : 'LightlineFiletype',
      \   'gitbranch'         : 'LightlineGitBranch',
      \ },
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ],
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ]
      \ },
      \ 'mode_map': {
        \ 'n': '🦋 N',
        \ 'i': 'I',
        \ 'v': 'V',
        \ 'V': 'VL',
        \ },
      \ }

let g:lightline.component_expand = {
      \   'buffers'          : 'lightline#bufferline#buffers',
      \   'coc_error'        : 'LightlineCocErrors',
      \   'coc_warning'      : 'LightlineCocWarnings',
      \   'coc_info'         : 'LightlineCocInfos',
      \   'coc_hint'         : 'LightlineCocHints',
      \   'coc_fix'          : 'LightlineCocFixes'
      \ }

let g:lightline.component_type = {
      \   'buffers'          : 'tabsel',
      \   'coc_error'        : 'error',
      \   'coc_warning'      : 'warning',
      \   'coc_info'         : 'tabsel',
      \   'coc_hint'         : 'middle',
      \   'coc_fix'          : 'middle',
      \   'linter_checking'  : 'left',
      \   'linter_warnings'  : 'warning',
      \   'linter_errors'    : 'error',
      \   'linter_ok'        : 'left',
      \ }


" === Lightline-bufferline options ===
set showtabline=2
let g:lightline#bufferline#filename_modifier = ':t'  " only filename, no path
let g:lightline#bufferline#unnamed           = '*'
let g:lightline#bufferline#more_buffers      = '…'
let g:lightline#bufferline#unicode_symbols   = 0
let g:lightline#bufferline#shorten_path      = 1
let g:lightline#bufferline#smart_path        = 1
let g:lightline#bufferline#enable_devicons   = 1
let g:lightline#bufferline#icon_position     = 'left'
let g:lightline#bufferline#min_buffer_count  = 2
let g:lightline#bufferline#clickable         = 1     " allow clickable tabs, setting 1
let g:lightline.component_raw = {'buffers': 1}       " allow clickable tabs, setting 2
let g:lightline.tabline = {'left': [['buffers']], 'right': [['']]}
let g:lightline#bufferline#show_number       = 1     " number buffers same as :ls
let g:lightline#bufferline#number_map        = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}


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

" Colorscheme settings need to occur before loading scheme
lua <<EOF
require("tokyonight").setup({
  style = "moon", -- Four styles: `storm`, `moon`, `night` and `day`
  transparent = false, -- Enable this to disable setting the background color
})
EOF

" Use color syntax highlighting
syntax on

" Use dark background
set background=dark

" Enable true color support.
" Note: macOS Terminal app doesn't support true color,
" set notermguicolors later in this file.
if !has('gui_running')
  if (has("termguicolors"))
    set termguicolors
    colorscheme tokyonight
    " colorscheme onedark
  endif
endif

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
autocmd! BufWritePre * :%s/\s\+$//e

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
" This option doesn't work in Neovim 0.11.x for some reason.
"set pastetoggle=<F4>

" Reload file after disk change, then notify.
" Guard against command history window errors: https://unix.stackexchange.com/questions/149209
" /refresh-changed-content-of-file-opened-in-vim/383044#comment1045364_383044
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

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
" Vim always creates a file to test writeability in directory,
" which causes all files to recompile and breaks IntelliSense.
" See: https://github.com/neoclide/coc.nvim/issues/649
setlocal nowritebackup
setlocal nobackup

set swapfile
set directory^=~/.nvim/swap//
"set writebackup                 " Protect against crash-during-write
"set nobackup                    " but do not persist backup after successful write.
set backupcopy=auto             " Use rename-and-write-new method whenever safe.
set backupdir^=~/.nvim/backup   " Consolidate the write backups.
set updatetime=100              " make CoC plugins much more responsive

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

" Better behavior with opening splits, like CopilotChatToggle
" https://github.com/CopilotC-Nvim/CopilotChat.nvim/discussions/124
lua <<EOF
  -- vim.opt.splitright=false
  vim.opt.splitright=true
  vim.opt.splitbelow=true
EOF

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

" Make background color transparent for git changes
hi! SignifySignAdd guibg=NONE
hi! SignifySignDelete guibg=NONE
hi! SignifySignChange guibg=NONE

" Highlight git change signs
hi! SignifySignAdd guifg=#99c794
hi! SignifySignDelete guifg=#ec5f67
hi! SignifySignChange guifg=#c594c5

" Disable True Color support on macOS Terminal
" Needs to be set after custom transparent color changes
if $TERM_PROGRAM ==# 'Apple_Terminal'
  set notermguicolors
  colorscheme desert
endif

" Always show the signcolumn (for git gutter), otherwise it will shift
" the text each time diagnostics appear or become resolved.
set signcolumn=yes

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

" Change Signify deleted line symbol
let g:signify_sign_delete = '-'

" Reload dev-icons after init source
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" === Miscellaneous ===
" Enable spellcheck for markdown files
"autocmd BufRead,BufNewFile *.md setlocal spell
set spelllang=en
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add

" Display current Neovim file in Ghostty terminal emulator tab title
lua << EOF
  -- %F: Full path to the current file
  -- %f: Relative path to file in the buffer
  -- %t: Current filename
  vim.opt.title = true
  vim.opt.titlestring = "%t"
EOF


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
" Close tab
nnoremap <silent> <leader>c :tabclose<CR>
" Toggle highlight at column 80
nnoremap <silent> <leader>cc :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>
" Find and replace word under cursor (mnemonic: c_u_rsor)
" ToggleZoom first to avoid resetting split layout
" nnoremap <leader>u :%s/<c-r><c-w>//g<left><left>
nnoremap <leader>u :call ToggleZoom(v:true)<CR>:%s/<c-r><c-w>//g<left><left>
" Close buffer w/o closing split
nnoremap <leader>q :Bwipeout<CR>
" Show hunk diff in gutter
nnoremap <leader>h :SignifyHunkDiff<CR>
" Switch to next buffer
nnoremap <leader>n :bn<CR>
" Switch to prev buffer
nnoremap <leader>b :bp<CR>
" Mark piece of text as foldable (doesn't work, don't know why)
"nnoremap <leader>d zf
" Toggle folds
nnoremap <leader>a za
" Delete buffer (capital D)
nnoremap <leader>D :bd<CR>
" Toggle hidden characters (capital H)
nnoremap <silent> <leader>H :set nolist!<CR>
" Insert empty line before and after
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<Left><Left><CR>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<Left><Left><CR>
" Run Prettier on whole file
nnoremap <leader>P :Prettier<CR>


" === Denite shortcuts === "
"   <leader>; - Fuzzy search open buffers (like FZF or Ctrl-P)
"   <leader>f - Browse list of files in current directory
"   <leader>t - Search for files in project directory
"   <leader>g - Search curr directory for given term, close window if no results
"   <leader>j - Search curr directory for occurrences of word under cursor
"   <leader>: - Fuzzy search command history (non-fuzzy default is q:)
"           i - After triggers above, press 'i' to enter fuzzy filter mode
"nmap <leader>; :Denite buffer<CR>
nmap <leader>; :Buffers<CR>
" nmap <leader>f :Denite file/rec<CR>
nnoremap <silent> <leader>f :Files<CR>
"nmap <leader>t :DeniteProjectDir file/rec<CR>i
nnoremap <leader>g :Rg<CR>
"nnoremap <leader>j :call ToggleZoom(v:true)<CR>:DeniteCursorWord grep:.<CR>
nnoremap <leader>: :History:<CR>

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

" nnoremap <silent> <Leader>0 <Plug>(zoom-toggle)
nnoremap <silent> <Leader>0 :call ToggleZoom(v:true)<CR>

" Ctrl-c remapped to Escape to avoid leftover artifacts with CoC menus.
" https://github.com/neoclide/coc.nvim/issues/1469
inoremap <C-c> <Esc>

" Switch to last open buffer with <leader>k
" Default of ctrl-^ (or ctrl-6) conflicts with Mosh interrupt
" This method doesn't work with unnamed buffers (ctrl-^ does)
nmap <leader>k :e #<CR>

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" Comment line using nvim-ts-context-commentstring
nmap <leader>/ gcc

" === key mappings for tab pages ===
nnoremap t. :tabedit %<CR>
nnoremap tc :tabclose<CR>

