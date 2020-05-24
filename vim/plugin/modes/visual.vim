"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual and Select
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maintain selection after indentation
vmap < <gv
vmap > >gv

" enable very magic mode during search operations
vnoremap / /\v

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" move between windows.
xnoremap <C-h> <C-w>h
xnoremap <C-j> <C-w>j
xnoremap <C-k> <C-w>k
xnoremap <C-l> <C-w>l

" move selection vertically within buffer
xnoremap <silent> K :call visual#move_up()<cr>
xnoremap <silent> J :call visual#move_down()<cr>
