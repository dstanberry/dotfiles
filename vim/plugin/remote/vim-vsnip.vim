"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-vsnip configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" select text to use ad $TM_SELECTED_TEXT in the next snippet
nmap s <plug>(vsnip-select-text)
" cut text to use ad $TM_SELECTED_TEXT in the next snippet
nmap S <plug>(vsnip-cut-text)

" expand snippet
smap <expr> <c-j> vsnip#expandable() ? '<plug>(vsnip-expand)' : '<c-j>'
" expand snippet or advance to next section
smap <expr> <c-l> vsnip#available(1) ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'
" advance to next section in snippet
smap <expr> <tab> vsnip#jumpable(1) ? '<plug>(vsnip-jump-next)' : '<tab>'
" advance to previous section in snippet
smap <expr> <s-tab> vsnip#jumpable(-1) ? '<plug>(vsnip-jump-prev)' : '<s-tab>'

" select text to use ad $TM_SELECTED_TEXT in the next snippet
xmap s <plug>(vsnip-select-text)
" cut text to use ad $TM_SELECTED_TEXT in the next snippet
xmap S <plug>(vsnip-cut-text)
