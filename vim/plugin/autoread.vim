"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Check file for disk changes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if ! exists ("g:checkFileStarted")
	let g:checkFileStarted=1
	call timer_start(1,'functions#checkFile')
endif
