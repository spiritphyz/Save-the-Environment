" Force python3
" https://robertbasic.com/blog/force-python-version-in-vim/
if has('python3')
endif

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

"Autoclose braces
"inoremap ( ()<Left>
"inoremap { {}<Left>
"inoremap [ []<Left>

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
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
set swapfile
 set directory^=~/.vim/swap//

" Protect against crash-during-write
 set writebackup
" but do not persist backup after successful write
set nobackup
" Use rename-and-write-new method whenever safe
set backupcopy=auto
" Patch required to honor double slash at end
if has("patch-8.1.0251")
  " consolidate the writebackups
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
set softtabstop=2 " # of spaces that counts as a tab during editing ops
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
colorscheme one
call one#highlight('Visual', 'ffffff', 'e06c75', 'none')
call one#highlight('vimLineComment', '888888', '', 'none')

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
" Ctrl-i: Ripgrep inside files
"map <C-p> :Buffers<CR>
"map <C-e> :Files<CR>
"map <C-i> :Ag<CR>

" Map Ctrl-n for NERDTree
map <C-n> :NERDTreeToggle<CR>

" Prettier plugin settings
nmap <Leader>pr <Plug>(Prettier)      " <leader>pr to run Prettier
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
let g:lightline.tabline = {'left': [['buffers']], 'right': [['close']]}

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


" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "
"
" ------------------------------------------------------------------------------
" Vim-Plug is the plugin manager to allow fast parallel updates
" https://github.com/junegunn/vim-plug
"
" Install updates with ':PlugInstall'
" List plugins with ':PlugStatus'
" ------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'
"
" Denite install requirements:
" -- Vim 8 compiled with if_python3
" -- pip3 install --user pynvim
if has('python3')
  set pyx=3
  let g:python3_host_prog = '/usr/bin/python3'
else
  set pyx=2
endif
if has('nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/denite.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
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

" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

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
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'statusline': 0,
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
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

" === Coc.nvim === "
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

" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
nmap ; :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-h>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
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

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-h>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
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
