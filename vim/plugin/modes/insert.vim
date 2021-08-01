"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Insert
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" shift current line down
inoremap c-j> <esc>:m .+1<cr>==i")
" shift current line up
inoremap c-k> <esc>:m .-2<cr>==i")

" define undo break point
inoremap , ,<c-g>u")
inoremap . .<c-g>u")
inoremap ! !<c-g>u")
inoremap ? ?<c-g>u")

" exit insert mode
inoremap jk <esc>
