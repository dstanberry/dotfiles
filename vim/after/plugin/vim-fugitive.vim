"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-fugitive configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-fugitive: execute git diff
nnoremap <localleader>gd :GVdiff<cr>

"vim-fugitive: execute git status
nnoremap <localleader>gs :Gstatus<cr>

"vim-fugitive: resolve git conflict using left hunk
nnoremap <localleader>gh :diffget //2<cr>

"vim-fugitive: resolve git conflict using right hunk
nnoremap <localleader>gl :diffget //3<cr>
