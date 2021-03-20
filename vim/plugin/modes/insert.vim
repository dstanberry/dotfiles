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

" vim-vsnip: expand snippet
imap <expr> <c-j> vsnip#expandable() ? '<plug>(vsnip-expand)' : '<c-j>'
" vim-vsnip: expand snippet or advance to next section
imap <expr> <c-l> vsnip#available(1) ? '<plug>(vsnip-expand-or-jump)' : '<c-l>'
" vim-vsnip: advance to next section in snippet
imap <expr> <tab> vsnip#jumpable(1) ? '<plug>(vsnip-jump-next)' : '<tab>'
" vim-vsnip: advance to previous section in snippet
imap <expr> <s-tab> vsnip#jumpable(-1) ? '<plug>(vsnip-jump-prev)' : '<s-tab>'
