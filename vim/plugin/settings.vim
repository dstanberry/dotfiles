"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set default encoding (must be at the beginning of this file)
set encoding=utf-8
scriptencoding utf-8

" define a colorscheme
colorscheme kdark

" enable file association and syntax file-based syntax support
filetype plugin indent on

" highlight conflicts
match ErrorMsg "^\(<\|=\|>\)\{7\}\([^=].\+\)\?$"

" enable syntax highlighting
syntax on

" enable true color within tmux
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" use solid block cursor in normal mode
let &t_EI="\<Esc>[2 q"
" use blinking vertical bar in insert mode
let &t_SI="\<Esc>[5 q"
" use blinking underscore cursor in replace mode
let &t_SR="\<Esc>[3 q"

if has('nvim')
  " define location for backup files
  set backupdir=$XDG_CACHE_HOME/nvim/backup//,.
  " define location for swap files
  set directory=$XDG_CACHE_HOME/nvim/swap//,.
  " define location for undo files
  set undodir=$XDG_CACHE_HOME/nvim/undo//,.
else
  " define location for backup files
  set backupdir=$XDG_CACHE_HOME/vim/backup//,.
  " define location for swap files
  set directory=$XDG_CACHE_HOME/vim/swap//,.
  " define location for undo files
  set undodir=$XDG_CACHE_HOME/vim/undo//,.
endif

" update file content if it has been modified on disk
set autoread
" auto-indent new line
set autoindent
" maintain file backup across sessions
set backup
" allow <backspace> to cross line boundaries
set backspace=indent,eol,start
" disable the system bell
set belloff=all
" set emphasis on wrapped lines
set breakindentopt=shift:2
" setup clipboard
set clipboard=unnamed,unnamedplus
" include dictionary in completion matches
set complete+=kspell
" use popup menu to show possible completions
set completeopt=menuone,noselect
" highlight current line
set cursorline
" define glyph used for vertical separator
set fillchars+=vert:┃
" define glyph used for line folds
set fillchars+=fold:·
" define glyph used for deleted lines in diff
set fillchars+=diff:∙
" define character used for empty lines at the end of a buffer
set fillchars+=eob:\ 
" set grep program to use
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
elseif executable('ag')
  set grepprg=ag\ --vimgrep\ --noheading\ --smart-case
elseif executable('ack')
  set grepprg=ack\ --nogroup\ --nocolor\ --column\ --no-heading\ --smart-case
else
  set grepprg=grep\ -R\ -n\ --exclude-dir=.git,.cache,node_modules
endif
" set grep output format
set grepformat=%f:%l:%c:%m
" allow buffers with unsaved changes to be hidden
set hidden
" highlight all search pattern matches
set hlsearch
" enable case insensitive search
set ignorecase
" enable live text substitution and preview matches
if exists('+inccommand')
  set inccommand=split
endif
" incremental highlight of matched patterns
set incsearch
" display the statusline
set laststatus=2
" show whitespace characters
set list
" set soft line wrapping
set linebreak
" define glyph used to visually identify tabs
set listchars+=tab:»\ 
" define glyph used to visually identify end of line
set listchars+=eol:¬
" define glyph used to visually identify trailing spaces
set listchars+=trail:•
" define glyph used to visually identify text overflow (right)
set listchars+=extends:›
" define glyph used to visually identify text overflow (left)
set listchars+=precedes:‹
" define glyph used to visually identify non-breaking spaces
set listchars+=nbsp:␣
" define glyph used to visually identify concealed text
set listchars+=conceal:┊
" enable search using regex expressions
set magic
" enable mouse features
set mouse=a
" disable error sounds
set noerrorbells
" disable padding when joining mulitple lines
set nojoinspaces
" disable redraw while executing macros
set nolazyredraw
" disable showing cursor position in/below statusline
set noruler
" disable showing keystrokes below statusline
set noshowcmd
" disable contextual message based on mode
set noshowmode
" disable title modification
set notitle
" show line numbers
set number
" toggle paste mode (to be able to accurately paste from external apps)
set pastetoggle=<F2>
" extend path to include current directory
set path+=**
" set opacity for popup menu
if exists('+pumblend')
  set pumblend=20
endif
" set the maximum number of entries shown in completion menu
set pumheight=5
" show line numbers relative to current line
set relativenumber
" rows: begin scrolling before reaching viewport boundary
set scrolloff=3
" set space indent width
set shiftwidth=4
" avoid swapfile alert messages
set shortmess+=A
" disable splash screen
set shortmess+=I
" disable showing file info
set shortmess+=F
" don't show completion menu messages
set shortmess+=c
" define line wrap character
set showbreak=↳
" show matching braces
set showmatch
" hide the tabline
set showtabline=0
" columns: begin scrolling before reaching viewport boundary
set sidescrolloff=3
" make search case sensitive if expression contains a capital letter
set smartcase
" indent based on code style
set smartindent
" tab will respect 'tabstop', 'shiftwidth', and 'softtabstop'
set smarttab
" prevent mixing tabs and whitespace
set softtabstop=0 noexpandtab
" default behaviour when creating new panes
set splitbelow splitright
"reuse windows/tabs if possible
set switchbuf=usetab
" set tab visible width
set tabstop=4
" enable true color
set termguicolors t_Co=256
" redraw buffer faster
set ttyfast
" maintain undo history across sessions
set undofile
" allow crossing of line boundaries
set whichwrap=b,h,l,s,<,>,[,],~
" enable enhanced command line completion
set wildmenu
" enable file auto-completion
set wildmode=full
" enable completion menu
if exists('+wildoptions')
  set wildoptions+=pum
endif
" enable line wrapping
set wrap
" define right margin before wrapping text
set wrapmargin=8
