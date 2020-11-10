"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Request expensive/greedy resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call functions#defer('call async#loadHashes()')
call functions#defer('call async#vimade()')
