"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => dirvish configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ensure dirvish is available
if !get(g:, 'loaded_dirvish', v:false)
  finish
endif

augroup dirvish_setup
  autocmd!
  autocmd FileType dirvish
        \ silent! nnoremap <nowait><silent><buffer> -
        \ :<c-u>.call dirvish#open('edit', 0)<cr>
augroup END
