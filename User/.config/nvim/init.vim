" Use Unicode characters. Has to be at the top of the file.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif

" Avoid slow startup time on cold starts
" Linux:
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
" macOS with Homebrew:
"let g:python_host_prog  = '/usr/bin/python'
"let g:python3_host_prog = '/usr/local/bin/python3'

" Load plugins
source ~/.config/nvim/plugins.vim

" Load custom Node to address incompatibility between NVM and COC
source ~/.config/nvim/nvm-coc.vim


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
nnoremap <CR> :noh<CR>

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

" for existing files, keep textwidths but don't let vim automatically reformat
" when typing on lines
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

" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'auto_resize': 1,
\ 'prompt': 'λ:',
\ 'direction': 'rightbelow',
\ 'winminheight': '10',
\ 'highlight_mode_insert': 'Visual',
\ 'highlight_mode_normal': 'Visual',
\ 'prompt_highlight': 'Function',
\ 'highlight_matched_char': 'Function',
\ 'highlight_matched_range': 'Normal'
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction


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

function! LightlineCocHints() abort
  return s:lightline_coc_diagnostic('hints', 'hint')
endfunction

autocmd User CocDiagnosticChange call lightline#update()

" Configure statusline
let g:lightline = {
      \ 'colorscheme': 'ayu_mirage',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ]
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
let g:lightline#bufferline#filename_modifier = ':t' " only filename, no path
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#unicode_symbols = 0
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline.tabline = {'left': [['buffers']], 'right': [['close']]}


" === NERDTree options ===
" Show hidden files/directories
let g:NERDTreeShowHidden = 1

" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']

" Automatically close the NerdTree buffer when opening a file
let g:NERDTreeQuitOnOpen = 1


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
" Note: macOS Terminal app doesn't support true color
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
" https://github.com/itchyny/lightline.vim/issues/406
augroup myvimrc
  au!
  au BufWritePost init.vim,plugins.vim ++nested so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

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

" Add underline to locate error position
hi! CocUnderline term=underline

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

" Reload dev-icons after init source
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif


" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" === Denite shorcuts === "
"   ctrl-p    - Browser currently open buffers
"   <leader>f - Browse list of files in current directory
"   <leader>g - Search curr directory for given term, close window if no results
"   <leader>j - Search curr directory for occurrences of word under cursor
nmap <C-p> :Denite buffer<CR>
nmap <leader>f :Denite file_rec<CR>
nnoremap <leader>g <C-u>:Denite grep:. -no-empty<CR>
nnoremap <leader>j :DeniteCursorWord grep:.<CR>

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
nnoremap <leader>b :bp<cr>
nnoremap <leader>d :bd<cr>

" Ctrl-hjkl for quick window switching (Vim split panes)
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Delete current visual selection and dump in black hole buffer before pasting
" Used when you want to paste over something without it getting copied to
" Vim's default buffer
vnoremap <leader>p "_dP


" === NERDTree key mappings ===
"  <leader>t - Toggle NERDTree on/off
"  <leader>f - Opens current file location in NERDTree
map <leader>t :NERDTreeToggle<CR>
map <leader>f :NERDTreeFind<CR>

" === coc-prettier key mappings ===
" Type :Prettier to format current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" Create range first, then <leader>p to Prettier format
map <leader>p <Plug>(coc-format-selected)

" === coc.nvim ===
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)

" === Abbreviations ===
" http://vim.wikia.com/wiki/Using_abbreviations
ab cll console.log(
ab fll for (var i = 0; i < x.length; i += 1) {}

