"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command (Line)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" move to the beginning of the command
cnoremap <C-a> <Home>
" move to the end of the command
cnoremap <C-e> <End>

" go the next match
cnoremap <expr> <Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-z>'
" go to the previous match
cnoremap <expr> <S-Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'