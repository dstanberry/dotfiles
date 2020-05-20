" define a mapleader for more key combinations
let mapleader="\<space>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" clear highlighted search matches
nnoremap <c-l> :nohl<cr><c-l> :echo "Search cleared"<cr>

" enable very magic mode during search operations
nnoremap / /\v

" avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" avoid unintentional switches to man(ual)
nnoremap K <nop>

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
nnoremap <tab> :bnext<cr>
" switch to previous buffer
nnoremap <s-tab> :bprevious<cr>

" switch to left window
nnoremap <leader>h :wincmd h<cr>
" switch to top window
nnoremap <leader>k :wincmd k<cr>
" switch to right window
nnoremap <leader>l :wincmd l<cr>
" switch to bottom window
nnoremap <leader>j :wincmd j<cr>

" increment window width
nnoremap <silent> <Leader>= :vertical resize +5<cr>
" decrement window width
nnoremap <silent> <Leader>- :vertical resize -5<cr>
" increment window height
nnoremap <silent> <Leader>+ :resize +5<cr>
" decrement window height
nnoremap <silent> <Leader>_ :resize -5<cr>

" trim trailing whitespace
nmap <leader>zz :call leader#trim()<cr>

" insert newline without entering insert mode
nnoremap o o<esc>
nnoremap O O<esc>

" capitalize all characters in string
nnoremap <c-u> viwU<esc>

" undotree: toggle undo-tree panel
nnoremap <leader>u :UndotreeToggle<cr>

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

" undotree: toggle the undo-tree panel
nnoremap <F5> :UndotreeToggle<cr>

"vim-fugitive: execute git status
nnoremap <leader>gs :G<cr>

"vim-fugitive: resolve git conflict using left hunk
nnoremap <leader>gf :diffget //2<cr>

"vim-fugitive: resolve git conflict using right hunk
nnoremap <leader>gh :diffget //3<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Local Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" create/edit file within the current directory
nnoremap <LocalLeader>e :edit <C-R>=expand('%:p:h') . '/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal, Visual, Select, Operator-pending
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" yank to end of line
noremap Y y$

" bind ctl-c to escape key
nnoremap <c-c> <esc>
