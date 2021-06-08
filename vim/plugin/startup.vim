"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Request expensive/greedy/time-sensitive resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lazy-load specific vim functions
call functions#defer('call deferred#load_dir_hash()')

" load lua startup function
if has('nvim-0.5')
  lua require('startup')
endif
