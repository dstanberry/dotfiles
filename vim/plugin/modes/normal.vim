" define a mapleader for more key combinations
let mapleader="\<space>"

" define a maplocalleader for more key combinations
let maplocalleader="\\"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle highlighting of search matches
nnoremap <f3> :set hlsearch!<cr>

" undotree: toggle the undo-tree panel
nnoremap <F5> :UndotreeToggle<cr>

" bind ctl-c to escape key
nnoremap <c-c> <esc>

" navigate quickfix list using arrow keys
nnoremap <silent> <up> :cprevious<cr>
nnoremap <silent> <down> :cnext<cr>
nnoremap <silent> <left> :cpfile<cr>
nnoremap <silent> <right> :cnfile<cr>

" enable very magic mode during search operations
nnoremap / /\v

" allow semi-colon to enter command mode
nnoremap ; :

" move to the beginningof the current line
nnoremap H ^

" avoid unintentional switches to man(ual)
nnoremap K <nop>

" move to the end of the current line
nnoremap L g_

" insert newline without entering insert mode
nnoremap o o<esc>
nnoremap O O<esc>

" disable recording to a register
nnoremap q <nop>

" avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" yank to end of line
noremap Y y$

" show directory of current file in explorer
nnoremap <silent> - :silent edit <c-r>=empty(expand('%')) ? '.' : expand('%:p:h')<cr><cr>

" store relative jumps in the jumplist if they exceed a threshold.
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" write current buffer to disk
nnoremap <leader>w :w<cr>
" close app
nnoremap <leader>q :q<cr>
" write current buffer to disk and close app
nnoremap <leader>x :x<cr>
" close the current buffer
nnoremap <leader>z :bd<cr>

" switch to next buffer
nnoremap <silent> <tab> :bnext<cr>
" switch to previous buffer
nnoremap <silent> <s-tab> :bprevious<cr>

" switch to left window
nnoremap <silent> <c-h> :wincmd h<cr>
" switch to top window
nnoremap <silent> <c-k> :wincmd k<cr>
" switch to right window
nnoremap <silent> <c-l> :wincmd l<cr>
" switch to bottom window
nnoremap <silent> <c-j> :wincmd j<cr>

" increment window width
nnoremap <silent> <leader>= :vertical resize +5<cr>
" decrement window width
nnoremap <silent> <leader>- :vertical resize -5<cr>
" increment window height
nnoremap <silent> <leader>+ :resize +5<cr>
" decrement window height
nnoremap <silent> <leader>_ :resize -5<cr>

" trim trailing whitespace
nmap <leader>zz :call  normal#trim()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf: list files available in the current directory
nnoremap <leader><leader> :Files<cr>
" fzf: list git files available in the current directory
nnoremap <leader>gi :GFiles<cr>
" fzf: list all currently open file buffers
nnoremap <leader><cr> :Buffers<cr>

" netrw: toggle netrw buffer
nnoremap <silent> <leader>n :call functions#netrwToggle()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Local Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" create/edit file within the current directory
nnoremap <localleader>e :edit <C-R>=expand('%:p:h') . '/'<cr>

"vim-fugitive: execute git diff
nnoremap <localleader>gd :GVdiff<cr>

"vim-fugitive: execute git status
nnoremap <localleader>gs :Gstatus<cr>

"vim-fugitive: resolve git conflict using left hunk
nnoremap <localleader>gh :diffget //2<cr>

"vim-fugitive: resolve git conflict using right hunk
nnoremap <localleader>gl :diffget //3<cr>
