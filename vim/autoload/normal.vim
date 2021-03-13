"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Wrapper to trim whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! normal#trim() abort
  call functions#substitute('\s\+$', '', '')
endfunction
