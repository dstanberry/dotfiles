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
  if has('nvim')
    autocmd FileType dirvish
          \ call dirvish#add_icon_fn({ p -> v:lua.GetDevIcon(p, p[-1:] == '/' ? '_dir_' : '') })
  endif
augroup END
