"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Request expensive/greedy/time-sensitive resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua require("deferred")

call functions#defer('call deferred#loadHashes()')
call functions#defer('call deferred#vimade()')

call functions#defer('lua startLSP()')
