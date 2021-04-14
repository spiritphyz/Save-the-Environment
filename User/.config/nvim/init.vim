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
let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Load plugins
source ~/.config/nvim/plugins.vim

" Load custom NodeJS version to address incompatibility
" between NVM (Node Version Manager) and CoC
source ~/.config/nvim/nvm-coc.vim


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

" Allow cursor to move past last character,
" automatically pad spaces on new character insert
" https://keleshev.com/my-book-writing-setup/
"set virtualedit=all


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
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!{__pycache__,node_modules,.git}'])

" Use ripgrep instead of grep
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on its own line
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

" Set project root so Denite won't be limited to parent of curr file
call denite#custom#option('_', 'root_markers', 'Pipfile, Makefile, .git')

" Custom options for Denite
"   auto_resize             - Auto resize the height automatically
"   direction               - Specify window as directly below curr pane
"   floating_preview        - For Neovim, open preview window as floating
"   winminheight            - Specify min height for Denite window
"   prompt                  - Customize denite prompt
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'start_filter': 0,
\ 'auto_resize': 1,
\ 'winminheight': '5',
\ 'direction': 'dynamicbottom',
\ 'floating_preview': 'true',
\ 'source_names': 'short',
\ 'prompt': ' ',
\ 'statusline': 0,
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'vertical_preview': 1
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


" === vim-markdown options ===
let g:vim_markdown_folding_disabled = 1
let g:markdown_enable_spell_checking = 0
let g:vim_markdown_fenced_languages = ['bash=sh', 'c', 'css', 'go', 'html', 'javascript', 'python', 'ruby', 'scss']
let g:vim_markdown_frontmatter = 1           " highlight YAML front matter
let g:vim_markdown_json_frontmatter = 1      " highlight JSON front matter
let g:vim_markdown_conceal = 0
let g:vim_markdown_new_list_item_indent = 2
autocmd FileType markdown highlight htmlH1 cterm=none ctermfg=70
autocmd BufNewFile,BufRead *.md set filetype=markdown


" === markdown-preview-nvim options ===
" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 1

" use a custom port to start server or random for empty
let g:mkdp_port = '8090'


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
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  if winwidth(0) < 70
    return filename[len(filename)-40:] . modified
  else
    return filename . modified
  endif
endfunction

" Ex: unix
function! LightlineFileformat()
  return winwidth(0) > 80 ? &fileformat : ''
endfunction

" Ex: utf-8
function! LightlineFileencoding()
  return winwidth(0) > 80 ? &fileencoding : ''
endfunction

" Ex: reactjavascript
function! LightlineFiletype()
  return winwidth(0) > 75 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineGitBranch()
  if exists ('*FugitiveHead')
  let branch = FugitiveHead()
  return branch !=# '' ? ' '.branch : ''
endfunction

function! LightlineCocHints() abort
  return s:lightline_coc_diagnostic('hints', 'hint')
endfunction

autocmd User CocDiagnosticChange call lightline#update()

" Configure statusline
let g:lightline = {
      \ 'colorscheme': 'ayu_mirage',
      \ 'component': {
      \   'fileformat': '%3l:%-2v%<',
      \   'filetype': '%3l:%-2v%<',
      \ },
      \ 'component_function': {
      \   'filename'          : 'LightlineFilename',
      \   'fileencoding'      : 'LightlineFileencoding',
      \   'fileformat'        : 'LightlineFileformat',
      \   'filetype'          : 'LightlineFiletype',
      \   'gitbranch'         : 'LightlineGitBranch'
      \ },
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ],
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ]
      \ },
      \ 'mode_map': {
        \ 'n': 'N',
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
let g:lightline.tabline = {'left': [['buffers']], 'right': [['close']]}
let g:lightline#bufferline#show_number       = 1     " number buffers same as :ls
let g:lightline#bufferline#number_map        = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}


" === NERDTree options ===
" Show hidden files/directories
let g:NERDTreeShowHidden = 1

" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '^node_modules$[[dir]]', '\.sass-cache$']

" Automatically close the NerdTree buffer when opening a file
let g:NERDTreeQuitOnOpen = 1

" Turn off help message banner at top, press ? to open it
" Press u to move up a directory, U to leave old root open
let NERDTreeMinimalUI=1


" === netrw options ===
" Open files in prev window unless we're opening the current dir
if argv(0) ==# '.'
    let g:netrw_browse_split = 0
else
    let g:netrw_browse_split = 4
endif


" === coc options ===
" These plugins will automatically be installed and updated by CoC
" :CocInstall to install the first time
" :CocUpdate to update the plugins
let g:coc_global_extensions = [
  \ "coc-css",
  \ "coc-eslint",
  \ "coc-html",
  \ "coc-json",
  \ "coc-prettier",
  \ "coc-python",
  \ "coc-tslint",
  \ "coc-tsserver"
  \]

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif


" === NeoSnippet === "
" Map <C-k> as shortcut to activate snippet in insert mode
" Type snippet's alias, then ctrl-k to circulate through insertion areas
" In command mode, ctrl-k is my Vim shortcut to navigate to lower split pane
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" Load custom snippets from snippets folder
let g:neosnippet#snippets_directory='~/.config/nvim/snippets'

" Hide conceal markers
let g:neosnippet#enable_conceal_markers = 0


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
" Change visually selected text to white for easier reading
call one#highlight('Visual', 'ffffff', 'e06c75', 'none')
" Make Vim comments and general comments be lighter gray for readability
call one#highlight('vimLineComment', '888888', '', 'none')
call one#highlight('Comment', '888888', '', 'none')

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
set pastetoggle=<F2>

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
" See: https://github.com/neoclide/coc.nvim/issues/649
"set swapfile
"set directory^=~/.nvim/swap//
"set writebackup                 " Protect against crash-during-write
"set nobackup                    " but do not persist backup after successful write.
"set backupcopy=auto             " Use rename-and-write-new method whenever safe.
"set backupdir^=~/.nvim/backup   " Consolidate the write backups.
set nobackup
set nowritebackup
set updatetime=100               " make coc plugins much more responsive

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

" For non-focused buffers, show absolute line numbers
function! ToggleLineNumsAndGutter()
  " Switch the toggle variable
  let g:toggle_linenum = !get(g:, 'toggle_linenum', 1)

  " Reset group
  augroup numbertoggle
    set nonumber
    set norelativenumber
    set signcolumn=no
    autocmd!
  augroup END

  " Enable if toggled on
  if g:toggle_linenum
    set number relativenumber
    set relativenumber

    if has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif

    augroup numbertoggle
      autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
      autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END
  endif
endfunction

" Better menu completion in command mode
set wildmenu
set wildmode=longest:full,full

" Don't give completion messages like 'match 1 of 2' or 'The only match'
"set shortmess+=c

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

" Always show the signcolumn (for git gutter), otherwise it will shift
" the text each time diagnostics appear or become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
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

" Change Signify deleted line symbol
let g:signify_sign_delete = '-'

" Reload dev-icons after init source
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" Automatically change current working directory to same as current buffer
set autochdir


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
nnoremap <leader>u :%s/<c-r><c-w>//g<left><left>
nnoremap <leader>q :lclose<bar>b#<bar>bd #<CR>       " Close buffer w/o closing split
nnoremap <leader>h :SignifyHunkDiff<CR>              " Show hunk diff in gutter
nnoremap <leader>n :bn<CR>                           " Switch to next buffer
nnoremap <leader>b :bp<CR>                           " Switch to prev buffer
nnoremap <leader>D :bd<CR>                           " Delete buffer (capital D)
" Toggle hidden characters (capital H)
nnoremap <silent> <leader>H :set nolist!<CR>
" Insert empty line before and after
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<Left><Left><CR>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<Left><Left><CR>


" === Denite shorcuts === "
"   <leader>L - Browser currently open buffers (capital L), like Vim's :ls
"   <leader>f - Browse list of files in current directory
"   <leader>t - Search for files in project directory
"   <leader>g - Search curr directory for given term, close window if no results
"   <leader>j - Search curr directory for occurrences of word under cursor
"   <leader>: - Fuzzy search command history (non-fuzzy default is q:)
"           i - After triggers above, press 'i' to enter fuzzy filter mode
nmap <leader>L :Denite buffer<CR>i
nmap <leader>f :Denite file/rec<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
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

" Remap <C-f> and <C-p> for scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-p> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-p>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-p> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-p> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-p>"
endif


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
vnoremap <leader>p "_dP


" === key mappings for tab pages ===
nnoremap t. :tabedit %<CR>
nnoremap tc :tabclose<CR>


" === NERDTree key mappings ===
"  <leader>r - Toggle NERDTree panel (<leader>n is next buffer)
"  <leader>e - Show current file in containing folder
map <leader>r :NERDTreeToggle<CR>
map <leader>e :NERDTreeFind<CR>

" === coc-prettier key mappings ===
" Type :Prettier to format current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" Create range first, then <leader>y to Prettier format
map <leader>y <Plug>(coc-format-selected)

" === coc.nvim ===
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dy <Plug>(coc-type-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)
nnoremap <silent> <leader>ds :<C-u>CocList -I -N --top symbols<CR>
" Jump to next eslint error
nmap <silent> ]e <Plug>(coc-diagnostic-next)
" Jump to prev eslint error
nmap <silent> [e <Plug>(coc-diagnostic-prev)
" Perform code action for word under cursor.
" Code actions are automaticed changes for a fix or issue,
" such as automatically importing a missing symbol.
nmap <leader>do <Plug>(coc-codeaction)
" Intelligent symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" === indentBlankline options ===
" Use UTF-8 glyph for indent character
"let g:indent_blankline_char = '¦'
" Use U+258F 'left one eigth block' glyph
" in Iosevka NerdFont
let g:indent_blankline_char = '▏'

" === Search shorcuts ===
"  <leader>s - For all lines in file, search and replace
map <leader>s :%s/


" === Miscellaneous ===
" Enable spellcheck for markdown files
autocmd BufRead,BufNewFile *.md setlocal spell
set spelllang=en
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add

