"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lazy Loading
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup DeferInit
	autocmd!
	if has('vim_starting')
		autocmd CursorHold,CursorHoldI * call functions#idleboot()
	endif
augroup END
