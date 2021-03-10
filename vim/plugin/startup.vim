"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Request expensive/greedy/time-sensitive resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lazy-load specific vim functions
call functions#defer('call deferred#loadHashes()')
call functions#defer('call deferred#vimade()')

" load lua startup functions
lua require("startup")
lua require("remote.lsp")
