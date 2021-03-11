"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Request expensive/greedy/time-sensitive resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lazy-load specific vim functions
call functions#defer('call deferred#loadHashes()')

" load lua startup functions
if has('nvim')
	lua require("startup")
	lua require("remote.lsp")
	lua require("remote.tree-sitter")
endif
