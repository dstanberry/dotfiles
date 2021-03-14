"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command (Line)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" move to the beginning of the command
cnoremap <C-a> <Home>
" move to the end of the command
cnoremap <C-e> <End>

" navigate completion menu using up/down keys
cnoremap <expr> <up> pumvisible() ? "<C-p>" : "<up>"
cnoremap <expr> <down> pumvisible() ? "<C-n>" : "<down>"

" exit command mode
cnoremap jk <c-c>

" the following breaks tab completioin in command mode
" go the next match
"cnoremap <expr> <tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-z>'
" go to the previous match
"cnoremap <expr> <s-tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'
