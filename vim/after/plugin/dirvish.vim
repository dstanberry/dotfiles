"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => dirvish configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ensure dirvish is available
if !get(g:, 'loaded_dirvish', v:false)
  finish
endif

function! s:get_icon(filepath) abort
  let l:func = "require('nvim-web-devicons').get_icon(vim.fn.fnamemodify('"
  let l:func .= a:filepath .. "', ':e')) or ' '"
  return luaeval(l:func)
endfunction

augroup DirvishConfig
  autocmd!
  autocmd FileType dirvish
        \ silent! nnoremap <nowait><silent><buffer> -
        \ :<c-u>.call dirvish#open('edit', 0)<cr>
  " if has('nvim')
  "   autocmd FileType dirvish
  "         \ call dirvish#add_icon_fn({ p -> s:get_icon(p) })
  " endif
augroup END
