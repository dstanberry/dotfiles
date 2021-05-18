"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" move to the beginning of the command
cnoremap <c-a> <Home>
" move to the end of the command
cnoremap <c-e> <End>

" the following breaks tab completion in command mode
" go the next match
"cnoremap <expr> <tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<cr>/<c-r>/' : '<c-z>'
" go to the previous match
"cnoremap <expr> <s-tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<cr>?<c-r>/' : '<s-tab>'

" navigate completion menu using up/down keys
cnoremap <expr> <up> pumvisible() ? "<c-p>" : "<up>"
cnoremap <expr> <down> pumvisible() ? "<c-n>" : "<down>"

" exit command mode
cnoremap jk <c-c>

" populate command line with path to file of current buffer
cnoremap %H <C-R>=expand('%:h:p') . functions#get_separator()<CR>

" populate command line with file name of current buffer
cnoremap %T <C-R>=expand('%:t')<CR>

" populate command line with path to parent dir of current buffer
cnoremap %P <C-R>=expand('%:p')<CR>
