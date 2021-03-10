"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Request expensive/greedy/time-sensitive resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim functions
call functions#defer('call deferred#loadHashes()')
call functions#defer('call deferred#vimade()')

" lua functions
lua require("startup")
call functions#defer('lua startLSP()')
