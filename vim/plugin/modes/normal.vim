"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (spacefn) navigate quickfix list
nnoremap <silent> <up> :cprevious<cr>zz
nnoremap <silent> <down> :cnext<cr>zz

" switch to next buffer
nnoremap <silent> <right> :bnext<cr>
" switch to previous buffer
nnoremap <silent> <left> :bprevious<cr>

" switch to next tab
nnoremap <silent> <tab> :tabnext<cr>
" switch to previous tab
nnoremap <silent> <s-tab> :tabprevious<cr>

" clear hlsearch if set, otherwise send default behaviour
nnoremap <expr> <cr> {-> v:hlsearch ? ":nohl<cr>" : "<cr>"}()

" navigate loclist list
nnoremap <silent> <a-k> :lprevious<cr>zz
nnoremap <silent> <a-j> :lnext<cr>zz

" find all occurences in buffer of word under cursor
nnoremap <c-f>f /\v<c-r><c-w><cr>

" begin substitution in buffer for word under cursor
nnoremap <c-f>r :%s/\<<c-r><c-w>\>/

" switch to left window
nnoremap <c-h> <c-w><c-h>
" switch to bottom window
nnoremap <c-j> <c-w><c-j>
" switch to top window
nnoremap <c-k> <c-w><c-k>
" switch to right window
nnoremap <c-l> <c-w><c-l>

" decrease active split horizontal size
nnoremap <c-,> <c-w><
" increase active split horizontal size
nnoremap <c-.> <c-w>>
" increase active split vertical size
nnoremap <a-,> <c-w>+
" decrease active split vertical size
nnoremap <a-.> <c-w>-

" enable very magic mode during search operations
nnoremap / /\v

" allow semi-colon to enter command mode
nnoremap ; :

" insert line break after parenthesis and comma
nnoremap gob  :s/\((\zs\\|,\ *\zs\\|)\)/\r&/g<cr><bar>:'[,']normal ==<cr>

" move to the beginning of the current line
nnoremap H ^

" keep cursor stationary when joining line(s) below
nnoremap J mzJ`z

" move to the end of the current line
nnoremap L g_

" keep screen centered when jumping between search matches
nnoremap n nzz
nnoremap N Nzz

" insert newline without entering insert mode
nnoremap o o<esc>
nnoremap O O<esc>

" disable recording to a register
nnoremap q <nop>

" avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" yank to end of line
nnoremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (try to) make all windows the same size
nnoremap <leader>= <c-w>=

" change text and preserve clipboard state
nmap <leader>c "_c
nmap <leader>C "_C

" delete text and preserve clipboard state
nmap <leader>d "_d
nmap <leader>D "_D

" shift current line down
nnoremap <leader>j :m .+1<cr>==
" shift current line up
nnoremap <leader>k :m .-2<cr>==

" write current buffer to disk if changed
nnoremap <leader>w :update<cr>
" close the current window or close app if this is the last window
nnoremap <leader>q :quit<cr>

" save current buffer to disk and execute the file
nnoremap <leader>x :call functions#execute_file()<cr>

" close the current buffer
nnoremap <silent> <leader>z :bdelete<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal | Local Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" populate command mode with last command
nnoremap <localleader>c :<up>

" create/edit file within the current directory
nnoremap <localleader>e :edit <c-r>=expand('%:p:h') . functions#get_separator()<cr>

" trim trailing whitespace
nnoremap <localleader>ff :call functions#trim()<cr>

" save as new file within the current directory
nnoremap <localleader>s :saveas <c-r>=expand('%:p:h') . functions#get_separator()<cr>

" discard all file modifications and close instance
nnoremap <localleader>qq ZQ

" execute current line
nnoremap <localleader>x :call functions#execute_line()<cr>

" discard changes to current buffer and close it
nnoremap <localleader>z :bdelete!<cr>
