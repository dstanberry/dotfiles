"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maintain selection after indentation
vmap < <gv
vmap > >gv

" enable very magic mode during search operations
vnoremap / /\v

" allow semi-colon to enter command mode
vmap ; :

" move between windows.
vnoremap <c-h> <c-w>h
vnoremap <c-j> <c-w>j
vnoremap <c-k> <c-w>k
vnoremap <c-l> <c-w>l

" move selection vertically within buffer
vnoremap <silent> K :call visual#move_up()<cr>
vnoremap <silent> J :call visual#move_down()<cr>

" begin substitution for current selection
vmap <c-r> :<bs><bs><bs><bs><bs>%s/<c-r>=visual#get_selection()<cr>//gc<left><left><left>
