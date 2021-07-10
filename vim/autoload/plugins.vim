"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Manager
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" install missing plugins at startup
augroup PLUGGED
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
        \| endif
augroup end

set encoding=utf-8

" define plugin installation directory
call plug#begin($XDG_CONFIG_HOME . '/vim/remote')

" command line fuzzy finder
Plug 'junegunn/fzf.vim', { 'on': ['Files', 'Buffers', 'Ag', 'Rg', 'Windows'] }
" distraction-free writing
Plug 'junegunn/goyo.vim'
" hyperfocus-writing
Plug 'junegunn/limelight.vim'
" emphasize the current matched search pattern
Plug 'wincent/loupe'
" easy text alignment
Plug 'godlygeek/tabular'
" file-type aware comments
Plug 'tpope/vim-commentary'
" fast and minimalist file explorer
Plug 'justinmk/vim-dirvish'
" create file and parent direcory at the same time
Plug 'duggiefresh/vim-easydir'
" a git wrapper for vim
Plug 'tpope/vim-fugitive'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
let g:Hexokinase_highlighters  = ['backgroundfull']
" highlight yanked text
Plug 'machakann/vim-highlightedyank'
" highlight sets of matching keywords
Plug 'andymass/vim-matchup'
" enable repeating actions with <.>
Plug 'tpope/vim-repeat'
" display git changes in gutter
Plug 'mhinz/vim-signify'
" snippet support
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
" start screen
Plug 'mhinz/vim-startify'
" surround sequence with tags
Plug 'tpope/vim-surround'
" enable focus events
Plug 'tmux-plugins/vim-tmux-focus-events'

call plug#end()
