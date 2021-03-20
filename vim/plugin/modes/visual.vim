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

" exit visual mode
vnoremap ZZ <esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Select | Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-vsnip: expand snippet
smap <expr> <c-j> vsnip#expandable() ? '<plug>(vsnip-expand)' : '<c-j>'
" vim-vsnip: expand snippet or advance to next section
smap <expr> <c-l> vsnip#available(1) ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'
" vim-vsnip: advance to next section in snippet
smap <expr> <tab> vsnip#jumpable(1) ? '<plug>(vsnip-jump-next)' : '<tab>'
" vim-vsnip: advance to previous section in snippet
smap <expr> <s-tab> vsnip#jumpable(-1) ? '<plug>(vsnip-jump-prev)' : '<s-tab>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual/Select | Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-vsnip: select text to use ad $TM_SELECTED_TEXT in the next snippet
xmap s <plug>(vsnip-select-text)
" vim-vsnip: cut text to use ad $TM_SELECTED_TEXT in the next snippet
xmap S <plug>(vsnip-cut-text)
