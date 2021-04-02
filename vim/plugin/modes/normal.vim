"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (spacefn) navigate quickfix list
nnoremap <silent> <up> :cprevious<cr>zz
nnoremap <silent> <down> :cnext<cr>zz
nnoremap <silent> <left> :cpfile<cr>
nnoremap <silent> <right> :cnfile<cr>

" bind ctl-c to escape key
nnoremap <c-c> <esc>

" navigate loclist list
nnoremap <silent> <a-k> :lprevious<cr>zz
nnoremap <silent> <a-j> :lnext<cr>zz
nnoremap <silent> <a-h> :lpfile<cr>
nnoremap <silent> <a-l> :lnfile<cr>

" clear hlsearch if set, otherwise send default behavviour
nnoremap <expr> <cr> {-> v:hlsearch ? ":nohl<cr>" : "<cr>"}()

" find all occurences in buffer of word under cursor
nnoremap <c-f>f /\v<c-r><c-w>

" begin substitution in buffer for word under cursor
nnoremap <c-f>r :%s/\<<c-r><c-w>\>//gc<left><left><left>

" begin substitution in quickfix list for word under cursor
nnoremap <c-f><space>
	  \ :cfdo %s/\<<c-r><c-w>\>//gce \| update
	  \ <left><left><left><left><left><left><left><left><left><left><left><left><left><left>

" enable very magic mode during search operations
nnoremap / /\v

" allow semi-colon to enter command mode
nnoremap ; :

" switch to next buffer
nnoremap <silent> <tab> :bnext<cr>
" switch to previous buffer
nnoremap <silent> <s-tab> :bprevious<cr>

" switch to next tab
nnoremap <silent> ]t :tabnext<cr>
" switch to previous tab
nnoremap <silent> [t :tabprevious<cr>

" move to the beginning of the current line
nnoremap H ^

" store relative jumps in the jumplist if they exceed a threshold.
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" move to the end of the current line
nnoremap L g_

" insert newline without entering insert mode
nnoremap o o<esc>
nnoremap O O<esc>

" disable recording to a register
nnoremap q <nop>

" avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" discard changes to all files and close window
nnoremap QQ ZQ

" yank to end of line
noremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define a mapleader for more key combinations
let mapleader=' '

" save current buffer to disk and source it
nnoremap <silent> <leader>0 :call functions#load_file()<cr>

" write current buffer to disk if changed
nnoremap <leader>w :update<cr>
" close the current window or close app if this is the last window
nnoremap <leader>q :quit<cr>

" close the current buffer
nnoremap <silent> <leader>d :bdelete<cr>

" switch to left window
nmap <silent> <leader>h :wincmd h<cr>
" switch to top window
nmap <silent> <leader>k :wincmd k<cr>
" switch to right window
nmap <silent> <leader>l :wincmd l<cr>
" switch to bottom window
nmap <silent> <leader>j :wincmd j<cr>

" increment window width
nnoremap <silent> <leader>= :vertical resize +5<cr>
" decrement window width
nnoremap <silent> <leader>- :vertical resize -5<cr>
" increment window height
nnoremap <silent> <leader>+ :resize +5<cr>
" decrement window height
nnoremap <silent> <leader>_ :resize -5<cr>

" trim trailing whitespace
nmap <leader>zz :call  functions#trim()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Local Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" define a maplocalleader for more key combinations
let maplocalleader='\'

" create/edit file within the current directory
nnoremap <localleader>e :edit <c-r>=expand('%:p:h') . '/'<cr>
