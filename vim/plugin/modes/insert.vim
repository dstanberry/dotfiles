"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Insert
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" exit insert mode
inoremap jk <esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Insert | Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" completion-nvim/vim-vsnip: launch completion menu
imap <silent> <c-space> <plug>(completion_trigger)
" completion-nvim/vim-vsnip: navigate to next item in completion menu
imap <expr> <tab> pumvisible() ? "<c-n>" : vsnip#jumpable(1) ? "<plug>(vsnip-jump-next)" : "<tab>"
" completion-nvim/vim-vsnip: navigate to previous item in completion menu
imap <expr> <s-tab> pumvisible() ? "<c-p>" : vsnip#jumpable(-1) ? "<plug>(vsnip-jump-prev)" : "<s-tab>"

" completion-nvim/vim-vsnip: navigate to next item in completion menu
imap <expr> <down>  pumvisible() ? "<c-n>" : "<down>"
" completion-nvim/vim-vsnip: navigate to previous item in completion menu
imap <expr> <up> pumvisible() ? "<c-p>" : "<up>"

" vim-vsnip: expand snippet
imap <expr> <c-j> vsnip#expandable() ? '<plug>(vsnip-expand)' : '<c-j>'
" vim-vsnip: expand snippet or advance to next section
imap <expr> <c-l> vsnip#available(1) ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'
