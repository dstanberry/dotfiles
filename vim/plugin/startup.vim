"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Request expensive/greedy/time-sensitive resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lazy-load specific vim functions
call functions#defer('call deferred#load_dir_hash()')

" load lua startup function
if has('nvim')
	lua require("startup")
endif
