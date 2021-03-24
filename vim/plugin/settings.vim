"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set default encoding
set encoding=utf8

" enable syntax highlighting
syntax on

" enable true color
set termguicolors t_Co=256
" enable true color within tmux
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" disable title modification
set notitle

" hide the tabline
set showtabline=0
" display the statusline
set laststatus=2

" enable file association and syntax file-based syntax support
filetype plugin indent on

" update file content if it has been modified on disk
set autoread

" enable case insensitive search
set ignorecase
" make search case sensitive if expression contains a capital letter
set smartcase
" highlight all search pattern matches
set hlsearch
" incremental highlight of matched patterns
set incsearch
" enable search using regex expressions
set magic

" disable redraw while executing macros
set nolazyredraw

" highlight current line
set cursorline
" show line numbers
set number
" show line numbers relative to current line
set relativenumber

" define right margin before wrapping text
set wrapmargin=8
" enable line wrapping
set wrap
" set soft line wrapping
set linebreak
" set emphasis on wrapped lines
set breakindentopt=shift:2
" define line wrap character
set showbreak=↳

" auto-indent new line
set autoindent
" indent based on code style
set smartindent

" show matching braces
set showmatch

" tab will respect 'tabstop', 'shiftwidth', and 'softtabstop'
set smarttab
" set tab visible width
set tabstop=4
" prevent mixing tabs and whitespace
set softtabstop=0 noexpandtab
" set space indent width
set shiftwidth=4

" disable contextual message based on mode
set noshowmode

" show whitespace characters
set list
" define glyphs used to visually identify invisible characters
set listchars=tab:│\ ,eol:¬,trail:⋅,extends:❯,precedes:❮

" define glyph used for vertical separator
set fillchars+=vert:┃
" defing glyph used for line folds
set fillchars+=fold:·
" defing glyph used for diffs
set fillchars+=diff:∙

" disable padding when joining mulitple lines
set nojoinspaces

" allow crossing of line boundaries
set whichwrap=b,h,l,s,<,>,[,],~

" allow buffers with unsaved changes to be hidden
set hidden

" enable enhanced command line completion
set wildmenu
" enable file auto-completion
set wildmode=full
" enable completion menu
if has('nvim')
  set wildoptions+=pum
endif

" set the maximum number of entries shown in completion menu
set pumheight=5

" default behaviour when creating new panes
set splitbelow splitright

" extend path to include current directory
set path+=**

" allow <backspace> to cross line boundaries
set backspace=indent,eol,start

" enable mouse features
set mouse=a

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

" maintain file backup across sessions
set backup
" maintain undo history across sessions
set undofile

" disable the system bell
set belloff=all
" disable error sounds
set noerrorbells
" set the internal bell to do nothing
set visualbell t_vb=

" redraw buffer faster
set ttyfast

"reuse windows/tabs if possible
"
set switchbuf=usetab

" rows: begin scrolling before reaching viewport boundary
set scrolloff=3
" columns: begin scrolling before reaching viewport boundary
set sidescrolloff=3

" enable case insensitive spell check
set spellcapcheck=

" setup clipboard
set clipboard=unnamed,unnamedplus

" toggle paste mode (to be able to accurately paste from external apps)
set pastetoggle=<F2>

" avoid swapfile alert messages
set shortmess+=A
" disable splash screen
set shortmess+=I
" disable showing file info
set shortmess+=F
" don't show completion menu messages
set shortmess+=c

" include dictionary in completion matches
set complete+=kspell
" use popup menu to show possible completions
set completeopt=menuone,noinsert,noselect

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

" use blinking vertical bar in insert mode
let &t_SI="\<Esc>[5 q"
" use blinking underscore cursor in replace mode
let &t_SR="\<Esc>[3 q"
" use solid block cursor in normal mode
let &t_EI="\<Esc>[2 q"

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

"define a colorscheme
colorscheme kdark
