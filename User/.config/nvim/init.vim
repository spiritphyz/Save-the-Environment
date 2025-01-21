" Use Unicode characters. Has to be at the top of the file.
if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  setglobal fileencodings=utf-8
endif

" Load plugins
source ~/.config/nvim/plugins.vim

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

" Allow folding based on TreeSitter syntax
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" When opening files, default to all folds open, not closed
autocmd BufReadPost,FileReadPost * normal zR
set nofoldenable


" ============================================================================ "
" ===                           PLUGIN OPTIONS                             === "
" ============================================================================ "

" === vim-markdown options ===
let g:markdown_enable_mappings = 0
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

" function! LightlineVimZoomStatus() abort
  " let status = g:zoom#statusline()
  " if status == 'zoomed'
  "   return '🔎'
  " else
  "   return ''
" endfunction

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

" Increase width of NERDTree window
:let g:NERDTreeWinSize=50

" Ensure that buffers don't open inside NerdTree split.
" If more than one window, and prev buffer was NERDTree, go back to it.
"autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif


" === netrw options ===
" Open files in prev window unless we're opening the current dir
if argv(0) ==# '.'
    let g:netrw_browse_split = 0
else
    let g:netrw_browse_split = 4
endif


" === coc options ===
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1):
  \ CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin.
" Check with --> :verbose imap <cr>
" Conflicts with auto autopairs:
" https://github.com/LunarWatcher/auto-pairs/issues/66
" Instead of <CR>, try ctrl-y to accept the current selection.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" These plugins will automatically be installed and updated by CoC
" :CocInstall to install the first time
" :CocUpdate to update the plugins
let g:coc_global_extensions = [
  \ "coc-css",
  \ "coc-emmet",
  \ "coc-eslint",
  \ "coc-format-json",
  \ "coc-html",
  \ "coc-json",
  \ "coc-prettier",
  \ "coc-python",
  \ "coc-styled-components",
  \ "coc-tslint",
  \ "coc-tsserver",
  \ "coc-vetur"
  \]

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif


" === NeoSnippet options ===
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


" === Rooter options ===
" All directories and files will trigger Rooter
let g:rooter_targets = '/,*'
" Root has these directories or filenames
let g:rooter_patterns = ['.git', 'Makefile', '.editorconfig']


" === Nvim-Treesitter ===
" configure treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  autotag = {                   -- autoclose HTML tags
    enable = true,
  },
  ensure_installed = {          -- "all" or a list of languages
    "bash", "c", "c_sharp", "clojure", "css",
    "dockerfile", "go", "html", "http",
    "java", "javascript", "json", "julia", "lua", "nix",
    "php", "python", "regex", "scheme", "scss",
    "toml", "tsx", "typescript", "vim", "vue", "yaml",
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {                 -- list of language that will be disabled
      "c", "markdown", "rust"
    },
  },
  indent = {                    -- indent based on = operator, experimental feature
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
    },
  },
}
EOF

" === Configure Nvim-Treesitter-Playground ===
lua <<EOF
require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
EOF

" === Configure Nvim-Treesitter-Context ===
lua <<EOF
-- Configure 'sticky scroll'
require'treesitter-context'.setup {
  -- enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      'class',
      'function',
      'method',
      'for',
      'while',
      'if',
      'switch',
      'case',
			'interface',
			'struct',
			'enum',
    },
    -- Patterns for specific filetypes
    -- If a pattern is missing, *open a PR* so everyone can benefit.
    tex = {
      'chapter',
      'section',
      'subsection',
      'subsubsection',
    },
    haskell = {
      'adt'
    },
    rust = {
      'impl_item',
    },
    terraform = {
      'block',
      'object_elem',
      'attribute',
    },
    scala = {
      'object_definition',
    },
    vhdl = {
      'process_statement',
      'architecture_body',
      'entity_declaration',
    },
    markdown = {
      'section',
    },
    elixir = {
      'anonymous_function',
      'arguments',
      'block',
      'do_block',
      'list',
      'map',
      'tuple',
      'quoted_content',
    },
    json = {
      'pair',
    },
    typescript = {
      'export_statement',
    },
    yaml = {
      'block_mapping_pair',
    },
    javascript = {
      'else_clause',
      'try_statement',
      'catch_clause',
    },
    vue = {
      -- works inside <template> tag
      'element',
      'start_tag',
      -- below doesn't work, trying for <script> tag
      'script_element',
      'raw_text',
      'export_statement',
      'pair',
      'method_definition',
      'property_identifier',
      'if_statement',
      'else_clause',
    },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust = true,
  },

  -- [!] The options below are exposed but shouldn't require your attention,
  --     you can safely ignore them.

  zindex = 20, -- The Z-index of the context window
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
}
EOF

" === Configure Nvim-Treesitter-Textobjects ===
lua <<EOF
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
  },
}
EOF

" === vim-matchup ===
" Place offscreen match as popup at top of screen with syntax highlighting.
" Highlighting popup cause performance degradation because Neovim doesn't provide relative line number
" in popup, https://github.com/andymass/vim-matchup/issues/253
" popup is still buggy inside splits, disabling it
" let g:matchup_matchparen_offscreen = {'method': 'popup', 'fullwidth': 1, 'syntax_hl': 1}
let g:matchup_matchparen_offscreen = {'method': 'status'}
let g:matchup_matchparen_deferred = 1

lua <<EOF
require'nvim-treesitter.configs'.setup {
  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
    disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    -- [options]
  },
}
EOF

" Change color of matched words and brackets
augroup matchup_matchparen_highlight
  autocmd!
  autocmd ColorScheme * hi MatchWord guifg=black guibg=darkgray
  autocmd ColorScheme * hi MatchParen guifg=black guibg=darkgray
augroup END


" === vim-js-pretty-template ===
" Register tag name associated the filetype
call jspretmpl#register_tag('gql', 'graphql')

autocmd FileType javascript JsPreTmpl
autocmd FileType javascript.jsx JsPreTmpl


" === LunarWatcher/auto-pairs options ===
" Change mappings from meta-based to control-based
"let g:AutoPairsCompatibleMaps = 0


" === Github Copilot options ===
" Disable SSL certificate verificaiton for Zscaler VPN.
" Also needs NODE_TLS_REJECT_UNAUTHORIZED=0 in ~/.zshrc.
" See --> :help g:copilot_proxy_strict_ssl
let g:copilot_proxy_strict_ssl = v:false

" Workspace folders to improve quality of suggestions.
let g:copilot_workspace_folders = [
  \ "~/kode/creativestudios-brc-backend"
  \]


" === fzf options ===
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" Enable highlight of found phrase in preview pane. All themes are buggy except base16.
" Also increase layout of FZF UI and preview window; highlight the match.
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--preview-window 'right,50%' --layout reverse --margin=0,1,0,1 --padding=0"
let $FZF_PREVIEW_COMMAND="COLORTERM=truecolor bat --theme='base16' --style=numbers --color=always --highlight-line 1:1 {}"


" === vim-remembers options ===
" let g:remembers_always_create = 1
" let g:remembers_always_reload = 0
" let g:remembers_tmp_dir     = '~/.nvim/remember-unnamed'
" let g:remembers_session_dir = '~/.nvim/remember-unnamed/sessions'


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

" Configure ondark colorscheme
lua <<EOF
  -- vim.g.onedark_style = 'dark'
  -- vim.g.onedark_italic_comment = true
  -- vim.g.onedark_diagnostics_undercurl = false
  -- vim.g.onedark_darker_diagnostics = true
  -- require('onedark').setup()
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

" === indentBlankline options ===
lua <<EOF
require("ibl").setup {
  -- Use U+258F 'left one eigth block' glyph in Iosevka NerdFont
  indent = { char = "▏" },
}
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
set pastetoggle=<F4>

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
      autocmd BufEnter,FocusGained,InsertLeave,WinEnter * set relativenumber
      autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * set norelativenumber
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

" coc color changes
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

" Automatically change current working directory to same as current buffer
" Doesn't work well, won't allow project-wide search from root folder
"set autochdir

" Don't automatically resize window splits when creating or closing windows.
" Helps NERDTreeToggle not clobber current widths of horizontal splits.
" https://stackoverflow.com/a/61732698
set noequalalways

" === Miscellaneous ===
" Enable spellcheck for markdown files
"autocmd BufRead,BufNewFile *.md setlocal spell
set spelllang=en
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add


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
nnoremap <leader>i :IBLToggle<CR>
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


" === FZF shortcuts ===
nmap <leader>; :Buffers<CR>
nnoremap <silent> <leader>f :Files<CR>
"nmap <leader>t :DeniteProjectDir file/rec<CR>i
nnoremap <leader>g :Rg<CR>
nnoremap <leader>: :History:<CR>
"nnoremap <leader>j :call ToggleZoom(v:true)<CR>:DeniteCursorWord grep:.<CR>

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

" Save folds
" augroup AutoSaveFolds
"   autocmd!
"   autocmd BufWinLeave * mkview
"   autocmd BufWinEnter * silent loadview
" augroup END

" nnoremap <silent> <Leader>0 <Plug>(zoom-toggle)
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

" Comment line using nvim-ts-context-commentstring
nmap <leader>/ gcc

" === key mappings for tab pages ===
nnoremap t. :tabedit %<CR>
nnoremap tc :tabclose<CR>


" === NERDTree key mappings ===
"  <leader>r - Toggle NERDTree panel (<leader>n is next buffer)
"  <leader>e - Show current file in containing folder
map <leader>r :NERDTreeToggle<CR>
map <leader>e :NERDTreeFind<CR>


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


" === coc-prettier key mappings ===
" Type :Prettier to format current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" Create range first, then <leader>y to Prettier format
map <leader>y <Plug>(coc-format-selected)


" === coc key mappings ===
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>gj <Plug>(coc-implementation)
nnoremap <silent> <leader>ds :<C-u>CocList -I -N --top symbols<CR>
" Jump to next eslint error
nmap <silent> ]e <Plug>(coc-diagnostic-next)
" Jump to prev eslint error
nmap <silent> [e <Plug>(coc-diagnostic-prev)
" Perform code action for word under cursor.
" Code actions are automaticed changes for a fix or issue,
" such as automatically importing a missing symbol.
nmap <leader>do <Plug>(coc-codeaction)
" Intelligent symbol renaming, which is F2 key in VSCode
nmap <leader>rn <Plug>(coc-rename)


" Remap <C-n> and <C-p> for selecting item in scrolling popup window
if has('nvim-0.4.0') || has('patch-8.2.0750')
  inoremap <silent><nowait><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
  inoremap <silent><nowait><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"
  inoremap <silent><nowait><expr> <down> coc#pum#visible() ? coc#pum#next(0) : "\<down>"
  inoremap <silent><nowait><expr> <up> coc#pum#visible() ? coc#pum#prev(0) : "\<up>"
  inoremap <silent><nowait><expr> <PageDown> coc#pum#visible() ? coc#pum#scroll(1) : "\<PageDown>"
  inoremap <silent><nowait><expr> <PageUp> coc#pum#visible() ? coc#pum#scroll(0) : "\<PageUp>"
  " Use <C-e> and <C-y> to cancel and confirm completion
  inoremap <silent><nowait><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"
  inoremap <silent><nowait><expr> <C-y> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"
endif


" === Search shorcuts ===
"  <leader>s - For all lines in file, search and replace
" Call ToggleZoom first to avoid resetting split layout
" map <leader>s :%s/
map <leader>s :call ToggleZoom(v:true)<CR>:%s/

" === vim-matchup shorcuts ===
"  <leader>? - show position in code as breadcrumb outline
nnoremap <leader>? :<c-u>MatchupWhereAmI??<cr>
