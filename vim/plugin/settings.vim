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
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" display the title
set title
" restore previous title
set titleold=

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
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮

" define glyph used for vertical separator
set fillchars+=vert:┃

" disable padding when joining mulitple lines
set nojoinspaces

" allow crossing of line boundaries
set whichwrap=b,h,l,s,<,>,[,],~

" enable enhanced command line completion
set wildmenu
" enable file auto-completion
set wildmode=list:longest

" default behaviour when creating new panes
set splitbelow splitright

" extend path to include current directory
set path+=**

" allow <backspace> to cross line boundaries
set backspace=indent,eol,start

" disable mouse in visual mode
set mouse=nicr

" define location for backup files
set backupdir=~/.config/vim/tmp/backup//,.
" define location for swap files
set directory=~/.config/vim/tmp/swap//,.
" define location for undo files
set undodir=~/.config/vim/tmp/undo//,.

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
set switchbuf=usetab

" rows: begin scrolling before reaching viewport boundary
set scrolloff=3
" columns: begin scrolling before reaching viewport boundary
set sidescrolloff=3

" enable case insensitive spell check
set spellcapcheck=

" toggle paste
set pastetoggle=<leader>v

" avoid swapfile alert messages
set shortmess+=A
" disable splash screen
set shortmess+=I

" use blinking vertical bar in insert mode
let &t_SI="\<Esc>[5 q"
" use blinking underscore cursor in replace mode
let &t_SR="\<Esc>[3 q"
" use solid block cursor in normal mode
let &t_EI="\<Esc>[2 q"

" define a mapleader for more key combinations
let mapleader = ' '

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'